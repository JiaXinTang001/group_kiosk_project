import 'package:flutter/material.dart';
import 'package:group_kiosk/OrderConfirmedScreen.dart';
import 'package:group_kiosk/AppData.dart'; // Handles global item clearing actions

class OnlineBankingScreen extends StatefulWidget {
  final double orderTotal; // Dynamic pricing amount parameter

  const OnlineBankingScreen({super.key, required this.orderTotal});

  @override
  State<OnlineBankingScreen> createState() => _OnlineBankingScreenState();
}

class _OnlineBankingScreenState extends State<OnlineBankingScreen> {
  // Default selected bank matching your layout list
  String _selectedBank = 'Bank Islam';

  // Bank names definition list matching your layout screen image specifications
  final List<Map<String, dynamic>> _banks = [
    {'name': 'Bank Islam'},
    {'name': 'Maybank2u'},
    {'name': 'CIMB bank'},
    {'name': 'RHB bank'},
    {'name': 'Bank Simpanan Nasional'},
    {'name': 'Hong Leong Bank'},
    {'name': 'Bank Rakyat'},
    {'name': 'Bank Muamalat'},
    {'name': 'Affin Bank'},
    {'name': 'Agro Bank'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Online banking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDFD), // Soft white card base container layout
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                itemCount: _banks.length,
                separatorBuilder: (context, index) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final bank = _banks[index];
                  final isSelected = _selectedBank == bank['name'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedBank = bank['name'];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      child: Row(
                        children: [
                          // Graphic Container Placeholder Box for individual Bank Logos
                          Container(
                            width: 70,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                bank['name'].toString().split(' ').first,
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              bank['name'],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                          ),
                          // Custom Radio button element indicator bubble matching your UI design
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? const Color(0xFFE76F2F) : const Color(0xffD9D9D9),
                            ),
                            child: isSelected
                                ? const Center(child: Icon(Icons.circle, size: 8, color: Colors.white))
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Action Bottom Payment Checkout Button Frame Panel Layout Container
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76F2F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // 1. Save order to data history map memory BEFORE resetting lists
                    AppData.saveCurrentOrderToHistory(widget.orderTotal);

                    // 2. Wipe the cart items completely clean
                    AppData.clearEntireCart();

                    // 3. FIXED: Cleaned up the broken block syntax loop and extra duplicate functions
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderConfirmedScreen(orderTotal: widget.orderTotal),
                      ),
                    );
                  },
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}