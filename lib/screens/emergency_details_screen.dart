import 'package:flutter/material.dart';
import 'sitter.dart';
import 'payment_screen.dart';

class EmergencyDetailsScreen extends StatefulWidget {
  final Sitter sitter;

  const EmergencyDetailsScreen({Key? key, required this.sitter})
    : super(key: key);

  @override
  State<EmergencyDetailsScreen> createState() => _EmergencyDetailsScreenState();
}

class _EmergencyDetailsScreenState extends State<EmergencyDetailsScreen> {
  int duration = 4;
  String details = "";

  @override
  Widget build(BuildContext context) {
    final double baseCost = widget.sitter.ratePerHour * duration;
    final double responseFee = baseCost * 0.15;
    final double totalCost = baseCost + responseFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Sitter Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(12),
                color: Colors.green.shade50,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(widget.sitter.img),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sitter.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text("${widget.sitter.distance} miles • ETA: 10 mins"),
                      ],
                    ),
                  ),
                  Text(
                    "\$${widget.sitter.ratePerHour}/hr",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Duration
            const Text(
              "Expected Duration (hours)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (duration > 1) {
                      setState(() => duration--);
                    }
                  },
                ),
                Text(
                  "$duration",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() => duration++);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Emergency details
            const Text(
              "Emergency Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Please describe the emergency situation...",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => details = val,
            ),
            const SizedBox(height: 20),

            // 🔹 Cost summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _costRow(
                    "Emergency Service ($duration hours)",
                    "\$${baseCost.toStringAsFixed(0)}",
                  ),
                  _costRow(
                    "Emergency Response Fee (15%)",
                    "\$${responseFee.toStringAsFixed(0)}",
                  ),
                  const Divider(),
                  _costRow(
                    "Total",
                    "\$${totalCost.toStringAsFixed(0)}",
                    bold: true,
                  ),
                ],
              ),
            ),
            const Spacer(),

            // 🔹 Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        sitter: widget.sitter, // ✅ Pass full Sitter object
                        date: DateTime.now(),
                        time: "Immediate",
                        duration: duration,
                        totalCost: totalCost,
                        specialRequests: details,
                        isEmergency: true,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Continue to Payment",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _costRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
