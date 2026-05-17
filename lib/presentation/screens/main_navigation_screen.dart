import 'package:flutter/material.dart';
import 'package:shopsmart/presentation/screens/cart_screen.dart';
import 'package:shopsmart/presentation/screens/home_screen.dart';
import 'package:shopsmart/presentation/screens/order_history_screen.dart';
import 'package:shopsmart/presentation/screens/profile_screen.dart';
import 'package:shopsmart/presentation/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;
  bool _isVisible = true;

  final screens = [
    const HomeScreen(),
    const CartScreen(),
    const SettingsScreen(),
    const OrderHistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.scrollDelta! > 10 && _isVisible) {
            setState(() => _isVisible = false);
          } else if (notification.scrollDelta! < -10 && !_isVisible) {
            setState(() => _isVisible = true);
          }
          return false;
        },
        child: screens[currentIndex],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isVisible
            ? 65.0 + MediaQuery.of(context).padding.bottom
            : 0,
        child: Wrap(
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              selectedIconTheme: const IconThemeData(size: 32),
              unselectedIconTheme: const IconThemeData(size: 24),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
              ),
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  _isVisible = true;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
