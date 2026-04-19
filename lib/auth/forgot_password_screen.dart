import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
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
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
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

      // Send password reset email ONLY - do NOT auto-login or reauthenticate
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password reset email sent! Check your inbox and follow the instructions.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        
        // Navigate back to login screen after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      String errorMessage = 'Failed to send reset email. Please try again.';
      final errorString = e.toString();
      debugPrint('Password reset error: $errorString');
      
      // Web-safe error handling: Use generic catch, safely check types
      bool handledByTypeCheck = false;
      
      // Safely try type check - may fail on web
      try {
        // Only check if it's FirebaseAuthException if the check doesn't throw
        if (e is FirebaseAuthException) {
          handledByTypeCheck = true;
          
          if (e.code == 'user-not-found') {
            errorMessage = 'No account found with this email address.';
          } else if (e.code == 'invalid-email') {
            errorMessage = 'Invalid email address.';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Too many requests. Please try again later.';
          } else if (e.code == 'network-request-failed') {
            errorMessage = 'Network error. Please check your internet connection.';
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
            lowerErrorString.contains('no user')) {
          errorMessage = 'No account found with this email address.';
        } else if (lowerErrorString.contains('invalid-email') ||
                   lowerErrorString.contains('invalid email')) {
          errorMessage = 'Invalid email address.';
        } else if (lowerErrorString.contains('network') || 
                   lowerErrorString.contains('connection')) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else if (lowerErrorString.contains('too-many-requests')) {
          errorMessage = 'Too many requests. Please try again later.';
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
                const SizedBox(height: 80),

                /// TITLE
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your email to receive a reset link.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 60),

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

                const SizedBox(height: 50),

                /// RESET PASSWORD BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : const Text(
                            "Send Reset Link",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

