import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:group_kiosk/TrackOrderScreen.dart';
import 'package:group_kiosk/AppData.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Order history', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE76F2F)));
          }

          if (!authSnapshot.hasData || authSnapshot.data == null) {
            return const Center(
              child: Text('Please log in to view your orders.', style: TextStyle(fontWeight: FontWeight.bold)),
            );
          }

          final String currentUserId = authSnapshot.data!.uid;

          return FutureBuilder<DataSnapshot>(
            future: AppData.database
                .ref()
                .child('orders')
                .orderByChild('userId')
                .equalTo(currentUserId)
                .get()
                .timeout(const Duration(seconds: 5)),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Database Sync Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFE76F2F)));
              }

              if (!snapshot.hasData || snapshot.data!.value == null) {
                return const Center(
                  child: Text(
                    'No past orders found!',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                );
              }

              final Map<dynamic, dynamic> ordersMap = snapshot.data!.value as Map<dynamic, dynamic>;
              final List<MapEntry<dynamic, dynamic>> orderEntries = ordersMap.entries.toList();

              orderEntries.sort((a, b) {
                final aTime = (a.value as Map)['createdAt'] as int? ?? 0;
                final bTime = (b.value as Map)['createdAt'] as int? ?? 0;
                return bTime.compareTo(aTime);
              });

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: orderEntries.length,
                itemBuilder: (context, index) {
                  final entry = orderEntries[index];
                  final String orderId = entry.key.toString();
                  final order = Map<String, dynamic>.from(entry.value as Map);

                  final String orderDate = order['date'] ?? 'Recent';
                  final List<dynamic> items = order['items'] ?? [];
                  final double totalAmount = (order['total'] ?? 0.0).toDouble();
                  final String orderStatus = order['status'] ?? 'Being prepared';

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
                              Text('Order #${orderId.substring(1, 6).toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(orderDate, style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
                                'RM ${totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(color: Color(0xFFE76F2F), fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 10),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.cookie_outlined, color: Colors.green, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Status: $orderStatus',
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFE76F2F),
                                ),
                                onPressed: () {
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
              );
            },
          );
        },
      ),
    );
  }
}