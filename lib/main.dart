import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'screens/onboarding.dart';
import 'auth/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

  runApp(WatchHubApp(onboardingSeen: onboardingSeen));
}

class WatchHubApp extends StatelessWidget {
  final bool onboardingSeen;
  const WatchHubApp({super.key, required this.onboardingSeen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _AuthGate(onboardingSeen: onboardingSeen),
    );
  }
}

class _AuthGate extends StatelessWidget {
  final bool onboardingSeen;
  const _AuthGate({required this.onboardingSeen});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase is still checking its local keychain / IndexedDB.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        // A persisted session was found — go straight to the app.
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // No session — onboarding on first launch, login screen after.
        return onboardingSeen ? const LoginScreen() : OnboardingScreen();
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0E1525),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE0B43A)),
        ),
      ),
    );
  }
}
