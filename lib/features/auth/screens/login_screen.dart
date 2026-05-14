import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_event.dart';
import 'package:shopsmart/features/auth/bloc/auth_state.dart';
import 'package:shopsmart/presentation/screens/main_navigation_screen.dart';
import 'package:shopsmart/routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,

          builder: (context, child) {
            double offset = sin(_animationController.value * 2 * pi) * 15;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MainNavigationScreen()),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                    
                      children: [
                        Transform.translate(
                          offset: Offset(0, offset),
                    
                          child: Image.asset(
                            'assets/icons/app_icon.png',
                            height: 150,
                          ),
                        ),
                        SizedBox(height: 30),
                        const Text(
                          "Welcome Back",
                    
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    
                        const SizedBox(height: 10),
                    
                        const Text(
                          "Login to continue shopping",
                    
                          style: TextStyle(
                            color: Color.fromARGB(255, 38, 37, 37),
                            fontSize: 16,
                          ),
                        ),
                    
                        const SizedBox(height: 40),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                    
                            filled: true,
                    
                            fillColor: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 30),
                    
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                35,
                                44,
                                54,
                              ),
                    
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 233, 254),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RouteNames.signup);
                              },
                              child: Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
