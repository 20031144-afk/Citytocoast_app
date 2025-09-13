import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String sitterName;
  final int sitterRate;
  final String sitterImg;
  final DateTimeRange range;
  final TimeOfDay time;

  const PaymentScreen({
    super.key,
    required this.sitterName,
    required this.sitterRate,
    required this.sitterImg,
    required this.range,
    required this.time,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 1;

  @override
  Widget build(BuildContext context) {
    // Calculate total
    int days = widget.range.duration.inDays + 1;
    int hours = 2; // Example: fixed 2 hrs/day
    int totalCost = widget.sitterRate * hours * days;

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
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.sitterImg),
                  radius: 30,
                ),
                title: Text(
                  widget.sitterName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${widget.range.start.day}/${widget.range.start.month} - "
                  "${widget.range.end.day}/${widget.range.end.month}\n"
                  "At ${widget.time.format(context)} • \$${widget.sitterRate}/hr",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Duration ($days day(s), $hours hrs/day)",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
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

            // Payment Methods
            RadioListTile<int>(
              value: 1,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
              title: const Text("Credit / Debit Card"),
              secondary: const Icon(Icons.credit_card, color: Colors.teal),
            ),
            RadioListTile<int>(
              value: 2,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
              title: const Text("Wallet"),
              secondary: const Icon(
                Icons.account_balance_wallet,
                color: Colors.teal,
              ),
            ),
            RadioListTile<int>(
              value: 3,
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val!),
              title: const Text("PayPal / UPI"),
              secondary: const Icon(Icons.payment, color: Colors.teal),
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
                      "Your booking with ${widget.sitterName} is confirmed.\n"
                      "Total Paid: \$$totalCost",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                          Navigator.pop(context);
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
