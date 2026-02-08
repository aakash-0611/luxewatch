// Splash screen

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../main.dart'; // HomeShell
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Keep your splash delay
    await Future.delayed(const Duration(seconds: 3));

    final loggedIn = await ApiService.isLoggedIn();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const HomeShell() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LUXEWATCH',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: cs.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white70),
          ],
        ),
      ),
    );
  }
}