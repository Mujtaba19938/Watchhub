import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'login_screen.dart';
import '../services/user_management_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userManagementService = UserManagementService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
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

      // Create user in Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'isBanned': false,
        'profileImageUrl': null,
      });

      // Also register in local management service for compatibility
      await _userManagementService.registerUser(
        email: email,
        name: name,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please log in.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Navigate to login screen after a short delay
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
        });
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      String errorMessage = 'Account creation failed. Please try again.';
      final errorString = e.toString();
      debugPrint('Sign up error: $errorString');
      
      // Web-safe error handling: Use generic catch, safely check types
      bool handledByTypeCheck = false;
      
      // Safely try type check - may fail on web
      try {
        // Only check if it's FirebaseAuthException if the check doesn't throw
        if (e is FirebaseAuthException) {
          handledByTypeCheck = true;
          
          if (e.code == 'weak-password') {
            errorMessage = 'The password provided is too weak.';
          } else if (e.code == 'email-already-in-use') {
            errorMessage = 'An account already exists for that email.';
          } else if (e.code == 'invalid-email') {
            errorMessage = 'The email address is invalid.';
          } else if (e.code == 'operation-not-allowed') {
            errorMessage = 'Email/password accounts are not enabled.';
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
        if (lowerErrorString.contains('email-already-in-use') || 
            lowerErrorString.contains('already exists')) {
          errorMessage = 'An account already exists for that email.';
        } else if (lowerErrorString.contains('weak-password') || 
                   (lowerErrorString.contains('password') && 
                    lowerErrorString.contains('weak'))) {
          errorMessage = 'The password provided is too weak.';
        } else if (lowerErrorString.contains('invalid-email') ||
                   lowerErrorString.contains('invalid email')) {
          errorMessage = 'The email address is invalid.';
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
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Start your premium collection today.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                /// FULL NAME FIELD
                const Text(
                  "Full Name",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: fieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

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

                const SizedBox(height: 30),

                /// CREATE ACCOUNT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                /// LOGIN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white60),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          color: gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
