import 'package:flutter/material.dart';
import 'package:group_kiosk/CheckoutScreen.dart';
import 'AppData.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onCartClear;

  const CartScreen({super.key, required this.onCartClear});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double subtotal = AppData.getSubtotal();
    double total = subtotal;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        title: const Text('My Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: AppData.globalCartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Your cart is empty', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: AppData.globalCartItems.length,
                itemBuilder: (context, index) {
                  final item = AppData.globalCartItems[index];
                  List<String> addons = List<String>.from(item['addons'] ?? []);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (addons.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Add-ons: ${addons.join(", ")}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            'RM ${item['price'].toStringAsFixed(2)}',
                            style: const TextStyle(color: Color(0xFFE76F2F), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: () {
                              setState(() {
                                if (item['qty'] > 1) {
                                  item['qty']--;
                                } else {
                                  AppData.globalCartItems.removeAt(index);
                                }
                              });
                              widget.onCartClear();
                            },
                          ),
                          Text('Qty: ${item['qty']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFFE76F2F)),
                            onPressed: () {
                              setState(() {
                                item['qty']++;
                              });
                              widget.onCartClear();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            _buildSummaryRow('Subtotal', 'RM ${subtotal.toStringAsFixed(2)}'),
            _buildSummaryRow('Total', 'RM ${total.toStringAsFixed(2)}', isTotal: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE76F2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                  ).then((_) {
                    widget.onCartClear();
                  });
                },
                child: const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? const Color(0xFFE76F2F) : Colors.black)),
        ],
      ),
    );
  }
}