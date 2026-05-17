import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsmart/routes/route_names.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "AI-Powered Shopping",
          body: "Experience the future of eCommerce with our AI-driven product recommendations tailored just for you.",
          image: const Center(child: Icon(Icons.psychology, size: 100, color: Colors.blue)),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
            bodyTextStyle: TextStyle(fontSize: 19.0),
          ),
        ),
        PageViewModel(
          title: "Fast & Secure Checkout",
          body: "Save time with our optimized checkout process and secure payment integrations.",
          image: const Center(child: Icon(Icons.speed, size: 100, color: Colors.green)),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
            bodyTextStyle: TextStyle(fontSize: 19.0),
          ),
        ),
        PageViewModel(
          title: "Exclusive Premium Benefits",
          body: "Go premium to remove all ads and unlock exclusive deals and faster delivery options.",
          image: const Center(child: Icon(Icons.star, size: 100, color: Colors.amber)),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
            bodyTextStyle: TextStyle(fontSize: 19.0),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
