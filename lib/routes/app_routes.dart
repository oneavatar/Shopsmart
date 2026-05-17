import 'package:flutter/material.dart';
import 'package:shopsmart/features/auth/screens/login_screen.dart';
import 'package:shopsmart/features/auth/screens/signup_screen.dart';
import 'package:shopsmart/presentation/screens/main_navigation_screen.dart';
import 'package:shopsmart/presentation/screens/onboarding_screen.dart';
import 'package:shopsmart/presentation/screens/splash_screen.dart';
import 'package:shopsmart/presentation/screens/profile_screen.dart';
import 'package:shopsmart/presentation/screens/cart_screen.dart';
import 'package:shopsmart/presentation/screens/checkout_screen.dart';

import 'route_names.dart';

class AppRoutes {

  static Route<dynamic>
  generateRoute(
      RouteSettings settings) {

    switch (settings.name) {
      
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case RouteNames.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case RouteNames.login:

        return MaterialPageRoute(
          builder: (_) =>
          const LoginScreen(),
        );

      case RouteNames.signup:

        return MaterialPageRoute(
          builder: (_) =>
          const SignupScreen(),
        );

      case RouteNames.home:

        return MaterialPageRoute(
          builder: (_) =>
          const MainNavigationScreen(),
        );
        
      case RouteNames.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      case RouteNames.cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );

      case RouteNames.checkout:
        return MaterialPageRoute(
          builder: (_) => const CheckoutScreen(),
        );

      default:

        return MaterialPageRoute(

          builder: (_) => Scaffold(

            body: Center(
              child: Text(
                "No route found",
              ),
            ),
          ),
        );
    }
  }
}