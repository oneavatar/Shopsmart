import 'package:flutter/material.dart';
import 'package:shopsmart/features/auth/screens/login_screen.dart';
import 'package:shopsmart/features/auth/screens/signup_screen.dart';
import 'package:shopsmart/presentation/screens/main_navigation_screen.dart';



import 'route_names.dart';

class AppRoutes {

  static Route<dynamic>
  generateRoute(
      RouteSettings settings) {

    switch (settings.name) {

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