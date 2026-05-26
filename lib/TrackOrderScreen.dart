import 'package:flutter/material.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Track order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text('Order ID: #UB-20483', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),

            // Countdown Timer UI Card Component
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Est. wait :', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.red[400],
                      child: const Text('5\nmin', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    const Text('Updates every 30s', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Order Status Timeline Tracker
            Expanded(
              child: ListView(
                children: [
                  _buildStatusStep('Order placed', '9:10 p.m - confirmed', true),
                  _buildStatusStep('Being prepared', 'Kitchen is cooking your order', true),
                  _buildStatusStep('Ready to collect', 'We\'ll notify you here', false),
                  _buildStatusStep('Picked up', 'Enjoy your meal!', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStep(String title, String subtitle, bool isDone) {
    return ListTile(
      leading: Icon(
        isDone ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isDone ? const Color(0xFFE76F2F) : Colors.grey,
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDone ? Colors.black : Colors.grey)),
      subtitle: Text(subtitle),
    );
  }
}