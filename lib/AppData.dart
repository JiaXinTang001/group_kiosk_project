import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
class AppData {
  static List<Map<String, dynamic>> globalCartItems = [];
  static List<Map<String, dynamic>> pastOrders = [];

  static FirebaseDatabase get database {
    return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://group-kiosk-default-rtdb.asia-southeast1.firebasedatabase.app',
    );
  }

  static double getSubtotal() {
    double total = 0;
    for (var item in globalCartItems) {
      total += (item['price'] * item['qty']);
    }
    return total;
  }

  static void clearEntireCart() {
    globalCartItems.clear();
  }

  static void saveCurrentOrderToHistory(double total) {
    if (globalCartItems.isNotEmpty) {
      pastOrders.add({
        'id': '#UB-${20000 + pastOrders.length * 7 + 83}', // Generates unique IDs
        'date': 'Today, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} p.m',
        'total': total,
        'items': List<Map<String, dynamic>>.from(globalCartItems),
      });
    }
  }
}