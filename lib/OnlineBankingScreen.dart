import 'package:flutter/material.dart';
import 'package:group_kiosk/OrderConfirmedScreen.dart';

class OnlineBankingScreen extends StatelessWidget {
  const OnlineBankingScreen({super.key});

  final List<String> banks = const [
    'Bank Islam', 'Maybank2u', 'CIMB Clicks', 'RHB Now',
    'BSN', 'Hong Leong Bank', 'Bank Rakyat', 'Affin Bank'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Online banking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: banks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.account_balance, color: Colors.grey),
                  title: Text(banks[index], style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Radio<int>(
                    value: index,
                    groupValue: 0, // Mock selection
                    activeColor: const Color(0xFFE76F2F),
                    onChanged: (val) {},
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE76F2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderConfirmedScreen()),
                  );
                },
                child: const Text('Pay Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}