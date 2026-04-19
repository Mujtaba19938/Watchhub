import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'services/user_service.dart';
import 'services/user_management_service.dart';
import 'auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase for all platforms
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
    
    // Set Firebase Auth persistence to LOCAL for web compatibility
    try {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      debugPrint('Firebase Auth persistence set to LOCAL');
    } catch (persistenceError) {
      // Persistence setting may fail on some platforms, continue anyway
      debugPrint('Could not set auth persistence (may not be supported on this platform): $persistenceError');
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue even if Firebase fails to initialize
  }
  
  // Initialize services
  try {
    final userManagementService = UserManagementService();
    await userManagementService.initialize();
    
    final userService = UserService();
    await userService.initialize();
  } catch (e) {
    debugPrint('Service initialization error: $e');
  }
  
  runApp(const WatchHubApp());
}

class WatchHubApp extends StatelessWidget {
  const WatchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _AuthWrapper(),
    );
  }
}

// Wrapper widget that listens to Firebase Auth state changes
class _AuthWrapper extends StatefulWidget {
  const _AuthWrapper();

  @override
  State<_AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<_AuthWrapper> {
  final _userService = UserService();
  final _userManagementService = UserManagementService();
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    // Wait for initial auth state before showing UI
    _waitForInitialAuthState();
  }

  Future<void> _waitForInitialAuthState() async {
    // Wait for the first auth state change to ensure Firebase Auth is ready
    // Use idTokenChanges() for more reliable web updates
    await FirebaseAuth.instance.idTokenChanges().first;
    
    // Check if user is banned
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final email = userData['email'] ?? firebaseUser.email ?? '';
          
          if (userData['isBanned'] == true || _userManagementService.isUserBanned(email)) {
            // User is banned, sign them out
            await FirebaseAuth.instance.signOut();
            await _userService.clearSession();
            debugPrint('AuthWrapper: Banned user signed out');
          } else {
            // Sync user data to UserService
            await _userService.setUser(
              email: email,
              name: userData['name'] ?? email.split('@')[0],
              profileImageUrl: userData['profileImageUrl'],
            );
          }
        } else if (firebaseUser.email != null) {
          // User exists in Auth but not in Firestore
          await _userService.setUser(
            email: firebaseUser.email!,
            name: firebaseUser.email!.split('@')[0],
          );
        }
      } catch (e) {
        debugPrint('AuthWrapper: Error checking user data: $e');
      }
    }
    
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      // Show loading screen while waiting for initial auth state
      return Scaffold(
        backgroundColor: const Color(0xFF0A0F1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE0B43A)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Use StreamBuilder to listen to auth state changes
    // Use idTokenChanges() for more reliable web updates
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state (only on first load)
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A0F1A),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE0B43A)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Get user from snapshot or directly from Firebase Auth as fallback
        final user = snapshot.data ?? FirebaseAuth.instance.currentUser;
        
        // If user is authenticated, show home screen
        if (user != null) {
          // Sync user data to UserService when auth state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncUserData(user);
          });
          return const HomeScreen();
        }
        
        // If user is not authenticated, show login screen
        return const LoginScreen();
      },
    );
  }

  Future<void> _syncUserData(User user) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final email = userData['email'] ?? user.email ?? '';
        
        await _userService.setUser(
          email: email,
          name: userData['name'] ?? email.split('@')[0],
          profileImageUrl: userData['profileImageUrl'],
        );
      } else if (user.email != null) {
        await _userService.setUser(
          email: user.email!,
          name: user.email!.split('@')[0],
        );
      }
    } catch (e) {
      debugPrint('AuthWrapper: Error syncing user data: $e');
    }
  }
}
