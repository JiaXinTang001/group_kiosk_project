import 'package:flutter/material.dart';
import 'package:group_kiosk/HomeScreen.dart';
import 'package:group_kiosk/MenuScreen.dart';
import 'package:group_kiosk/CartScreen.dart';
import 'package:group_kiosk/ProfileScreen.dart';
import 'AppData.dart'; // Import storage vault link

class MainNavigationScreen extends StatefulWidget {
  final String username;

  const MainNavigationScreen({super.key, required this.username});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void clearCart() {
    setState(() {
      AppData.globalCartItems.clear(); // Clears vault directly
    });
  }

  void updateCartState() {
    setState(() {}); // Triggers navigation container to repaint
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(username: widget.username, onCartUpdated: updateCartState),
      MenuScreen(onCartUpdated: updateCartState),
      CartScreen(onCartClear: updateCartState),
      ProfileScreen(matricNo: widget.username),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE76F2F),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          updateCartState(); // Forces page reload when switching tabs
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}