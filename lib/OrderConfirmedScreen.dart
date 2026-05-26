import 'package:flutter/material.dart';
import 'package:group_kiosk/TrackOrderScreen.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Icon(Icons.check, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Order placed !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Your food is being prepared. We\'ll notify you when it\'s ready.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildReceiptRow('Order ID', '#UB-20483'),
                    _buildReceiptRow('Pickup Time', 'Today, 9:30 p.m'),
                    const Divider(),
                    _buildReceiptRow('Total', 'RM 15.50', isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE76F2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrackOrderScreen()),
                  );
                },
                child: const Text('Track my order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: isBold ? const Color(0xFFE76F2F) : Colors.black)),
        ],
      ),
    );
  }
}