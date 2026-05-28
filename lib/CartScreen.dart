import 'package:flutter/material.dart';
import 'package:group_kiosk/AppData.dart';
import 'package:group_kiosk/CheckoutScreen.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onCartClear;

  const CartScreen({super.key, required this.onCartClear});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = AppData.globalCartItems;
    final subtotal = AppData.getSubtotal();

    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        title: const Text('My Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty!',
          style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final List<dynamic> addons = item['addons'] ?? [];
                final String? specialRequest = item['specialRequest'];
                final String? imagePath = item['image'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [

                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imagePath != null
                                ? Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.fastfood, color: Colors.grey);
                              },
                            )
                                : const Icon(Icons.fastfood, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              if (addons.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Add-ons: ${addons.join(', ')}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                              // 💡 ADDED: Displays custom notes securely if the student typed any
                              if (specialRequest != null && specialRequest.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  "Note: \"$specialRequest\"",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                                ),
                              ],
                              const SizedBox(height: 6),
                              Text(
                                'RM ${(item['price'] * item['qty']).toStringAsFixed(2)}',
                                style: const TextStyle(color: Color(0xFFE76F2F), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFE76F2F)),
                              onPressed: () {
                                setState(() {
                                  if (item['qty'] > 1) {
                                    item['qty']--;
                                  } else {
                                    cartItems.removeAt(index);
                                  }
                                });
                              },
                            ),
                            Text(
                              '${item['qty']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE76F2F)),
                              onPressed: () {
                                setState(() {
                                  item['qty']++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('RM ${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                        );
                      },
                      child: const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}