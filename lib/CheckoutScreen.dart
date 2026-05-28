import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_kiosk/OnlineBankingScreen.dart';
import 'package:group_kiosk/OrderConfirmedScreen.dart';
import 'package:group_kiosk/AppData.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'Online banking';
  bool _isCheckingOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pickup details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.location_on_outlined, color: Color(0xFFE76F2F)),
                      title: Text('Pickup at'),
                      subtitle: Text('Cafeteria Utama, Block A'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.access_time, color: Color(0xFFE76F2F)),
                      title: Text('Pickup time'),
                      subtitle: Text('Today, 9:30 p.m'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Payment method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildPaymentOption('Cash on pickup', 'Pay at counter', Icons.monetization_on_outlined),
            _buildPaymentOption('Touch \'n Go eWallet', 'Scan QR to pay', Icons.qr_code_scanner),
            _buildPaymentOption('Online banking', 'FPX transfer', Icons.account_balance_outlined),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: _isCheckingOut
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFE76F2F)))
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE76F2F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to place an order!')),
                    );
                    return;
                  }

                  if (AppData.globalCartItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Your cart is empty!')),
                    );
                    return;
                  }

                  if (_selectedPayment == 'Online banking') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnlineBankingScreen(orderTotal: AppData.getSubtotal()),
                      ),
                    );
                    return;
                  }

                  setState(() { _isCheckingOut = true; });

                  try {
                    final double finalTotal = AppData.getSubtotal();

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
                      'paymentMethod': _selectedPayment,
                    };

                    final docRef = AppData.database.ref().child('orders').push();

                    await docRef.set(newOrder);

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
                        SnackBar(content: Text('Checkout Failed: ${e.toString()}')),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() { _isCheckingOut = false; });
                    }
                  }
                },
                child: const Text(
                  'Place Order',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon) {
    return Card(
      child: RadioListTile<String>(
        activeColor: const Color(0xFFE76F2F),
        secondary: Icon(icon, color: const Color(0xFFE76F2F)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: title,
        groupValue: _selectedPayment,
        onChanged: (value) {
          setState(() {
            _selectedPayment = value!;
          });
        },
      ),
    );
  }
}