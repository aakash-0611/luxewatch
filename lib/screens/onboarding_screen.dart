//Onboarding screen introducing app features to users

import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<_OnboardData> slides = const [
    _OnboardData(
      title: 'Luxury Meets Technology',
      desc: 'Browse the world’s most exquisite timepieces from top brands.',
      image: 'assets/images/ap_ro.png',
    ),
    _OnboardData(
      title: 'Curated Just for You',
      desc: 'Personalized recommendations based on your taste and style.',
      image: 'assets/images/tag_carrera.png',
    ),
    _OnboardData(
      title: 'Easy Shopping Experience',
      desc: 'Smooth checkout and fast delivery at your fingertips.',
      image: 'assets/images/watch3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final s = slides[i];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(s.image, height: 240),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          s.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.desc,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  height: 8,
                  width: _page == i ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _page == i ? cs.primary : Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: FilledButton(
                onPressed: () {
                  if (_page == slides.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  } else {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(cs.primary),
                  foregroundColor: const WidgetStatePropertyAll(Colors.black),
                  padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 32, vertical: 14)),
                ),
                child: Text(_page == slides.length - 1 ? 'Continue' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final String title, desc, image;
  const _OnboardData({required this.title, required this.desc, required this.image});
}
