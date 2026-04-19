import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../admin/admin_login_screen.dart';
import '../services/user_service.dart';
import '../services/user_management_service.dart';
import '../screens/home_screen.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userService = UserService();
  final _userManagementService = UserManagementService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    // Navigate to forgot password screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ForgotPasswordScreen(),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE0B43A)),
          ),
        ),
      );

      // Ensure Firebase is initialized
      bool firebaseInitialized = false;
      try {
        Firebase.app();
        firebaseInitialized = true;
      } catch (e) {
        debugPrint('Firebase not initialized, initializing now: $e');
        try {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          firebaseInitialized = true;
          debugPrint('Firebase initialized successfully');
        } catch (initError) {
          debugPrint('Firebase initialization failed: $initError');
          if (mounted) Navigator.of(context).pop(); // Close loading dialog
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Firebase is not available. Please try again later.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          return;
        }
      }

      if (!firebaseInitialized) {
        if (mounted) Navigator.of(context).pop(); // Close loading dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Firebase is not available. Please try again later.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return;
      }

      // Set auth persistence to LOCAL for web compatibility
      try {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      } catch (persistenceError) {
        // Persistence setting may fail on some platforms, continue anyway
        debugPrint('Could not set auth persistence: $persistenceError');
      }

      // Sign in with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Try to get user data from Firestore
      Map<String, dynamic>? userData;
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          userData = userDoc.data();
        }
      } catch (firestoreError) {
        // If Firestore access fails, log it but continue with login
        debugPrint('Firestore read error: $firestoreError');
        // Continue with login using email only
      }

      if (userData != null) {
        // Check if user is banned
        if (userData['isBanned'] == true || _userManagementService.isUserBanned(email)) {
          // Close loading dialog
          if (mounted) Navigator.of(context).pop();
          
          // Sign out from Firebase
          await FirebaseAuth.instance.signOut();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You are banned. Please contact admin for account recovery.'),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 4),
              ),
            );
          }
          return;
        }

        // Set user in local service
        await _userService.setUser(
          email: email,
          name: userData['name'] ?? email,
          profileImageUrl: userData['profileImageUrl'],
        );

        // Also sync with local management service
        final localUser = _userManagementService.getUserByEmail(email);
        if (localUser == null) {
          await _userManagementService.registerUser(
            email: email,
            name: userData['name'] ?? email,
            profileImageUrl: userData['profileImageUrl'],
          );
        }
      } else {
        // User exists in Auth but not in Firestore - try to create Firestore entry
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': email,
            'name': email.split('@')[0],
            'createdAt': FieldValue.serverTimestamp(),
            'isBanned': false,
          });
        } catch (firestoreError) {
          // If Firestore write fails, log it but continue with login
          debugPrint('Firestore write error: $firestoreError');
        }

        await _userService.setUser(email: email);
      }

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Verify user is authenticated
      if (mounted && FirebaseAuth.instance.currentUser != null) {
        // Manually navigate to home screen as fallback
        // The StreamBuilder will also handle this, but manual navigation ensures immediate feedback
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false, // Remove all previous routes
        );
        debugPrint('Login successful, navigated to HomeScreen');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      String errorMessage = 'Login failed. Please check your email and password.';
      final errorString = e.toString();
      debugPrint('Login error: $errorString');
      
      // Web-safe error handling: Use generic catch, safely check types
      // On web, Firebase exceptions are wrapped differently
      bool handledByTypeCheck = false;
      
      // Safely try type check - may fail on web
      try {
        // Only check if it's FirebaseAuthException if the check doesn't throw
        if (e is FirebaseAuthException) {
          handledByTypeCheck = true;
          
          if (e.code == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided.';
          } else if (e.code == 'invalid-email') {
            errorMessage = 'The email address is invalid.';
          } else if (e.code == 'user-disabled') {
            errorMessage = 'This user account has been disabled.';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Too many failed login attempts. Please try again later.';
          } else if (e.message != null) {
            errorMessage = e.message!;
          }
        } else if (e is FirebaseException) {
          // Try FirebaseException for Firestore errors
          handledByTypeCheck = true;
          if (e.code == 'permission-denied') {
            errorMessage = 'Permission denied. Please check Firestore security rules.';
          } else if (e.message != null) {
            errorMessage = e.message!;
          }
        }
      } catch (typeError) {
        // Type check failed (common on web), will use string matching below
        debugPrint('Type check failed (web compatibility): $typeError');
      }
      
      // Use string matching for web compatibility or as fallback
      if (!handledByTypeCheck) {
        final lowerErrorString = errorString.toLowerCase();
        if (lowerErrorString.contains('user-not-found') || 
            lowerErrorString.contains('no user') ||
            lowerErrorString.contains('there is no user record')) {
          errorMessage = 'No user found for that email.';
        } else if (lowerErrorString.contains('wrong-password') || 
                   (lowerErrorString.contains('password') && 
                    !lowerErrorString.contains('reset') &&
                    !lowerErrorString.contains('forgot'))) {
          errorMessage = 'Wrong password provided.';
        } else if (lowerErrorString.contains('invalid-email') ||
                   lowerErrorString.contains('invalid email')) {
          errorMessage = 'The email address is invalid.';
        } else if (lowerErrorString.contains('user-disabled')) {
          errorMessage = 'This user account has been disabled.';
        } else if (lowerErrorString.contains('too-many-requests')) {
          errorMessage = 'Too many failed login attempts. Please try again later.';
        } else if (lowerErrorString.contains('permission-denied') || 
                   lowerErrorString.contains('permission')) {
          errorMessage = 'Permission denied. Please check Firestore security rules.';
        } else if (lowerErrorString.contains('network') ||
                   lowerErrorString.contains('connection')) {
          errorMessage = 'Network error. Please check your internet connection.';
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    const fieldColor = Color(0xFF1B2433);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E1525),
              Color(0xFF0A0F1A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// TITLE
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Login to continue your journey.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                /// EMAIL FIELD
                const Text(
                  "Email Address",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                /// PASSWORD FIELD
                const Text(
                  "Password",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _handleForgotPassword(),
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                /// SIGNUP LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white60),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// DIVIDER
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),

                const SizedBox(height: 20),

                /// ADMIN LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminLoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: gold,
                      side: BorderSide(color: gold, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Log in with admin",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
