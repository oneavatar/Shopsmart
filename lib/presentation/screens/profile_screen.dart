import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_event.dart';
import 'package:shopsmart/presentation/screens/order_history_screen.dart';
import 'package:shopsmart/presentation/screens/premiun_screen.dart';
import 'package:shopsmart/routes/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),

            const SizedBox(height: 20),

            const Text(
              "Sohan Thapa",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Flutter Developer",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.shopping_bag),

              title: const Text("My Orders"),

              trailing: const Icon(Icons.arrow_forward),

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

              trailing: const Icon(Icons.arrow_forward),

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
            ),

            ListTile(
              leading: const Icon(Icons.logout),

              title: const Text("Logout"),
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
    );
  }
}
