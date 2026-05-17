import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsmart/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final showOnboarding = prefs.getBool('showOnboarding') ?? true;

    if (showOnboarding) {
      Navigator.pushReplacementNamed(context, RouteNames.onboarding);
    } else {
      // For now, go to login. In a real app, check auth status here.
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 22, 42),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/icons/app_icon.png',
          height: 150,
          width: 150,
          
        ),
      ),
    );
  }
}
