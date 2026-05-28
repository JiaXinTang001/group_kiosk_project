import 'package:flutter/material.dart';
import 'package:group_kiosk/HomeScreen.dart';
import 'package:group_kiosk/MenuScreen.dart';
import 'package:group_kiosk/CartScreen.dart';
import 'package:group_kiosk/ProfileScreen.dart';
import 'AppData.dart';

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
      AppData.globalCartItems.clear();
    });
  }

  void updateCartState() {
    setState(() {});
  }

  int _getCartItemCount() {
    return AppData.globalCartItems.fold<int>(
        0,
            (sum, item) => sum + (item['qty'] as int? ?? 0)
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(username: widget.username, onCartUpdated: updateCartState),
      MenuScreen(onCartUpdated: updateCartState),
      CartScreen(onCartClear: clearCart),
      ProfileScreen(matricNo: widget.username),
    ];

    int cartCount = _getCartItemCount();

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
          updateCartState();
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),

          BottomNavigationBarItem(
            icon: cartCount > 0
                ? Badge(
              label: Text('$cartCount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFFE76F2F),
              child: const Icon(Icons.shopping_cart_outlined),
            )
                : const Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),

          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}