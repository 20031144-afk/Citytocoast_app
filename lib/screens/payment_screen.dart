import 'package:flutter/material.dart';
import 'payment_status_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String sitterName;
  final int sitterRate;
  final String sitterImg;
  final DateTimeRange range;
  final TimeOfDay time;
  final int hoursPerDay;

  const PaymentScreen({
    super.key,
    required this.sitterName,
    required this.sitterRate,
    required this.sitterImg,
    required this.range,
    required this.time,
    required this.hoursPerDay,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 1;

  @override
  Widget build(BuildContext context) {
    int days = widget.range.duration.inDays + 1;
    int totalCost = widget.sitterRate * widget.hoursPerDay * days;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Payment Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Payment methods
            _paymentMethodTile(
              1,
              "Visa Classic",
              "**** 1254",
              "https://img.icons8.com/color/48/visa.png",
            ),
            _paymentMethodTile(
              2,
              "MasterCard",
              "**** 2541",
              "https://img.icons8.com/color/48/mastercard.png",
            ),
            _paymentMethodTile(
              3,
              "Bank Transfer",
              "**** 3126",
              "https://img.icons8.com/color/48/bank.png",
            ),

            const SizedBox(height: 20),

            // Payment info
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.info, color: Colors.teal),
                title: Text("From: Client"),
                subtitle: Text("To: ${widget.sitterName}"),
              ),
            ),
            const Spacer(),

            // Total cost
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$$totalCost",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Pay button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentStatusScreen(
                      sitterName: widget.sitterName,
                      totalCost: totalCost,
                      method: _selectedMethod == 1
                          ? "Visa Classic"
                          : _selectedMethod == 2
                          ? "MasterCard"
                          : "Bank Transfer",
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Pay \$$totalCost",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodTile(
    int value,
    String title,
    String subtitle,
    String iconUrl,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Image.network(iconUrl, height: 30),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Radio<int>(
          value: value,
          groupValue: _selectedMethod,
          onChanged: (val) => setState(() => _selectedMethod = val!),
        ),
        onTap: () => setState(() => _selectedMethod = value),
      ),
    );
  }
}
