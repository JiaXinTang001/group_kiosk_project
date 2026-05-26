class AppData {
  // A single, globally accessible instance of your cart array list
  static final List<Map<String, dynamic>> globalCartItems = [];

  // Helper method to calculate totals anywhere in the app
  static double getSubtotal() {
    return globalCartItems.fold(0, (sum, item) => sum + (item['price'] * item['qty']));
  }
}