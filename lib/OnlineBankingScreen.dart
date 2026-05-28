import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_kiosk/OrderConfirmedScreen.dart';
import 'package:group_kiosk/AppData.dart';

class OnlineBankingScreen extends StatefulWidget {
  final double orderTotal;

  const OnlineBankingScreen({super.key, required this.orderTotal});

  @override
  State<OnlineBankingScreen> createState() => _OnlineBankingScreenState();
}

class _OnlineBankingScreenState extends State<OnlineBankingScreen> {
  String _selectedBank = 'Bank Islam';
  bool _isProcessing = false;

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
                color: const Color(0xFFFFFDFD),
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
                      if (!_isProcessing) {
                        setState(() {
                          _selectedBank = bank['name'];
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      child: Row(
                        children: [
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

          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: _isProcessing
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFE76F2F)))
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76F2F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please log in to finish checkout!')),
                      );
                      return;
                    }

                    if (AppData.globalCartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your cart is empty!')),
                      );
                      return;
                    }

                    setState(() { _isProcessing = true; });

                    try {
                      final double finalTotal = widget.orderTotal;

                      final now = DateTime.now();
                      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      final String formattedDate = "${now.day} ${months[now.month - 1]} ${now.year}";

                      List<Map<String, dynamic>> orderItems = AppData.globalCartItems.map((item) {
                        return {
                          'name': item['name'],
                          'qty': item['qty'],
                          'price': item['price'],
                        };
                      }).toList();

                      final Map<String, dynamic> newOrder = {
                        'userId': user.uid,
                        'date': formattedDate,
                        'items': orderItems,
                        'total': finalTotal,
                        'status': 'Being prepared',
                        'createdAt': DateTime.now().millisecondsSinceEpoch,
                        'paymentMethod': 'Online Banking ($_selectedBank)',
                      };

                      final docRef = AppData.database.ref().child('orders').push();

                      await docRef.set(newOrder);

                      AppData.saveCurrentOrderToHistory(finalTotal);

                      setState(() {
                        AppData.clearEntireCart();
                      });

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmedScreen(
                              orderTotal: finalTotal,
                              orderId: docRef.key,
                            ),
                          ),
                        );
                      }

                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment Sync Failed: ${e.toString()}')),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() { _isProcessing = false; });
                      }
                    }
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