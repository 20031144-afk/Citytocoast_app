import 'package:flutter/material.dart';
import 'sitter.dart';

class ConfirmationScreen extends StatelessWidget {
  final Sitter sitter;
  final String bookingRef;
  final DateTime date;
  final String time;
  final String paymentMethod;
  final bool isEmergency;

  const ConfirmationScreen({
    Key? key,
    required this.sitter,
    required this.bookingRef,
    required this.date,
    required this.time,
    required this.paymentMethod,
    this.isEmergency = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Icon(
              Icons.check_circle,
              size: 80,
              color: isEmergency ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              isEmergency
                  ? "Emergency Booking Confirmed!"
                  : "Booking Confirmed!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isEmergency
                  ? "Your emergency booking has been confirmed. ${sitter.name} is on the way and will contact you shortly."
                  : "Your booking has been successfully confirmed. ${sitter.name} will be in touch with you shortly.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isEmergency ? Colors.red.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Booking Reference: $bookingRef",
                style: TextStyle(color: isEmergency ? Colors.red : Colors.blue),
              ),
            ),

            const SizedBox(height: 30),
            _nextStep(
              Icons.call,
              "Sitter will contact you",
              "Within the next 30 minutes to confirm details",
            ),
            _nextStep(
              Icons.event_available,
              "Pre-service check-in",
              "24 hours before your booking",
            ),
            _nextStep(
              Icons.schedule,
              "Service begins",
              "At your scheduled time",
            ),

            const Spacer(),

            // 🔹 Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: Text("Message ${sitter.name.split(' ')[0]}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("View Booking"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Add to Calendar"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text("← Back to Home"),
            ),
            const SizedBox(height: 10),
            Text(
              "Need help or have questions? Contact our support team at support@sitcare.com or (555) 123-4567",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextStep(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(desc, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
