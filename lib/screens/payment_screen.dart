import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String sitterName;
  final int sitterRate;
  final DateTime date;
  final TimeOfDay time;

  const PaymentScreen({
    super.key,
    required this.sitterName,
    required this.sitterRate,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Example: assume booking for 2 hours
    int hours = 2;
    int totalCost = sitterRate * hours;

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Booking Summary
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://via.placeholder.com/100",
                  ),
                  radius: 30,
                ),
                title: Text(
                  sitterName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${date.day}/${date.month}/${date.year} at ${time.format(context)}\nRate: \$$sitterRate/hr",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Duration (2 hrs)",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  "\$$totalCost",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),

            // Payment Options (placeholder)
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("Pay with Card"),
              trailing: Radio(value: 1, groupValue: 1, onChanged: (_) {}),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("Pay with Wallet"),
              trailing: Radio(value: 2, groupValue: 1, onChanged: (_) {}),
            ),

            const Spacer(),

            // Confirm button
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text("Payment Successful"),
                    content: Text(
                      "Your booking with $sitterName is confirmed.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx); // close dialog
                          Navigator.pop(context); // back to booking
                          Navigator.pop(context); // back to homepage
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Pay \$$totalCost"),
            ),
          ],
        ),
      ),
    );
  }
}
