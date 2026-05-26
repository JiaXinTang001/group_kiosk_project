import 'package:flutter/material.dart';
import 'package:group_kiosk/AppData.dart';
import 'package:group_kiosk/TrackOrderScreen.dart'; // Imports your interactive tracker screen

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = AppData.pastOrders;

    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Order history', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? const Center(
        child: Text(
          'No past orders found!',
          style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final order = history[index];
          final List<dynamic> items = order['items'];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order['id'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(order['date'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const Divider(height: 20),
                  Column(
                    children: items.map<Widget>((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['name']} x${item['qty']}', style: const TextStyle(fontSize: 14)),
                            Text('RM ${(item['price'] * item['qty']).toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Paid', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        'RM ${order['total'].toStringAsFixed(2)}',
                        style: const TextStyle(color: Color(0xFFE76F2F), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 10),
                  const SizedBox(height: 8),

                  // ADDED: Live Status Tracker Action Button Row Block
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.cookie_outlined, color: Colors.green, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Status: Being prepared',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFE76F2F),
                        ),
                        onPressed: () {
                          // Direct route jump straight to your visual Order Status Tracking timeline screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TrackOrderScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.analytics_outlined, size: 16),
                        label: const Text(
                          'Track Progress',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}