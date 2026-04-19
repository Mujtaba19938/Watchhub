
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/app_gradient_bg.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController controller = PageController();
  int index = 0;

  final pages = [
    {
      "image": "assets/images/img1.png",
      "title": "Discover Timeless\nElegance",
      "subtitle": "Explore curated collections of the world's most prestigious timepieces."
    },
    {
      "image": "assets/images/img2.png",
      "title": "Curated For\nConnoisseurs",
      "subtitle": "Our experts hand-pick every piece ensuring authenticity."
    },
    {
      "image": "assets/images/img3.png",
      "title": "Join The WatchHub",
      "subtitle": "Create an account to build your wishlist and receive offers."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (v) => setState(() => index = v),
                  itemBuilder: (context, i) {
                    final p = pages[i];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(p["image"]!, height: 260),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            p["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            p["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              pages.length,
                              (dot) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: index == dot ? 12 : 8,
                                height: index == dot ? 12 : 8,
                                decoration: BoxDecoration(
                                  color: index == dot ? Colors.amber : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (index == pages.length - 1) {
                                // Mark onboarding complete so future cold
                                // starts go straight to LoginScreen.
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('onboarding_seen', true);
                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                }
                              } else {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              }
                            },
                            child: Text(
                              index == pages.length - 1 ? "Get Started" : "Next",
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
