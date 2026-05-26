import 'package:flutter/material.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3), // Matches your app's background shade
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Policies', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'UniBite Kiosk Terms & Policies',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 6),
            Text(
              'Last updated: May 2026',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // 1. Ordering & Collection Policy
            _buildPolicySection(
              title: '1. Ordering & Collection',
              content: 'All orders placed through the UniBite campus kiosk must be collected at the designated counter terminal within 30 minutes of preparation completion. Unclaimed meals will be disposed of for food safety hygiene reasons and are non-refundable.',
            ),

            // 2. Cancellation & Refund Policy
            _buildPolicySection(
              title: '2. Cancellation & Refunds',
              content: 'Once a digital transaction payment (FPX, Cash, or E-Wallet) is securely processed and sent to the kitchen display backend queue, the order cannot be amended or cancelled. Refunds are only issued if an item runs out of stock at the vendor stall.',
            ),

            // 3. Digital Privacy & Student Data Protection
            _buildPolicySection(
              title: '3. Student Data & Privacy',
              content: 'UniBite strictly handles student account profiles securely. Your matric card identification information, authentication log records, and purchase history are stored in a local environment solely to display past transactions on your profile panel dashboard.',
            ),

            // 4. Fair Use Campus Guidelines
            _buildPolicySection(
              title: '4. Fair Use Guidelines',
              content: 'Students are prohibited from exploiting system vulnerabilities, simulating artificial checkout flows, or providing fraudulent transaction numbers. Violation of terminal policies may result in the limitation of student kiosk portal privileges.',
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                'Thank you for cooperating with UniBite Campus Services.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Visual helper method to style each individual policy section card beautifully
  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE76F2F)),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            textAlign: TextAlign.justify, // Fixed compiler type alignment parameter
          ),
        ],
      ),
    );
  }
}