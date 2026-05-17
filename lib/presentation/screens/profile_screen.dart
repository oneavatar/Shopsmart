import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shopsmart/core/theme/bloc/theme_bloc.dart';
import 'package:shopsmart/core/theme/bloc/theme_event.dart';
import 'package:shopsmart/features/auth/bloc/auth_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_event.dart';
import 'package:shopsmart/presentation/screens/order_history_screen.dart';
import 'package:shopsmart/presentation/screens/premium_screen.dart';
import 'package:shopsmart/routes/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String name = "User";
                  String subTitle = "";
                  
                  if (state is AuthSuccess) {
                    name = state.user.displayName ?? state.user.email?.split('@').first ?? "User";
                    subTitle = state.user.email ?? "No email provided";
                  }
                  
                  return Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subTitle,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text("My Orders"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text("Go Premium"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PremiumScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                trailing: const Icon(Icons.settings),
                onTap: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text("Privacy Policy"),
                onTap: () => _launchURL("https://example.com/privacy"),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text("Terms of Service"),
                onTap: () => _launchURL("https://example.com/terms"),
              ),
              ListTile(
                leading: const Icon(Icons.support_agent),
                title: const Text("Contact Support"),
                onTap: () => _launchURL("mailto:support@shopsmart.com"),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteNames.login,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
