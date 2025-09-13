import 'package:flutter/material.dart';

class PaymentStatusScreen extends StatelessWidget {
  final String sitterName;
  final int totalCost;
  final String method;

  const PaymentStatusScreen({
    super.key,
    required this.sitterName,
    required this.totalCost,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Payment Status")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.check_circle,
              color: Colors.blue,
              size: 120,
            ), // ✅ success icon
            const SizedBox(height: 20),
            const Text(
              "Payment Successful",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your booking is confirmed.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Details card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow("Payment Method", method),
                    _infoRow("Sitter", sitterName),
                    _infoRow(
                      "Date",
                      DateTime.now().toString().split(" ").first,
                    ),
                    _infoRow(
                      "Transaction ID",
                      "TXN${DateTime.now().millisecondsSinceEpoch}",
                    ),
                    _infoRow("Total", "\$$totalCost"),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Back to Home
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Back to Home",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
