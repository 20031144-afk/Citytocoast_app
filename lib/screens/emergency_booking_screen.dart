import 'package:flutter/material.dart';
import 'emergency_details_screen.dart';
import 'sitter.dart';

class EmergencyBookingScreen extends StatelessWidget {
  const EmergencyBookingScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> emergencySitters = const [
    {
      "name": "Maria Santos",
      "rating": 4.8,
      "reviews": 156,
      "distance": 0.3,
      "rate": 35,

      "eta": "8 mins",
      "tags": ["Emergency Care", "Babysitting"],
      "available": true,
    },
    {
      "name": "James Wilson",
      "rating": 4.9,
      "reviews": 203,
      "distance": 0.5,
      "rate": 42,
      "eta": "12 mins",
      "tags": ["Emergency Pet Care", "Veterinary Assistant"],
      "available": true,
    },
    {
      "name": "Lisa Chen",
      "rating": 4.7,
      "reviews": 89,
      "distance": 0.7,
      "rate": 38,
      "eta": "Unavailable",
      "tags": ["Emergency Care", "Newborn Specialist"],
      "available": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Booking"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Info Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.info, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Emergency bookings are prioritized and include immediate response. Additional fees apply.",
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Available Emergency Sitters",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          ...emergencySitters.map((sitter) => _sitterCard(context, sitter)),
          const SizedBox(height: 20),

          // 🔹 Features
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency Booking Features:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text("• Immediate response (under 20 minutes)"),
                Text("• Priority booking over regular requests"),
                Text("• Emergency-trained certified sitters"),
                Text("• 24/7 support hotline included"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sitterCard(BuildContext context, Map<String, dynamic> sitter) {
    return GestureDetector(
      onTap: sitter["available"]
          ? () {
              Navigator.pushNamed(
                context,
                '/emergencyDetails',
                arguments: Sitter.fromMap(sitter),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: sitter["available"] ? Colors.white : Colors.grey.shade100,
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage("https://placekitten.com/200/200"),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sitter["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text("${sitter["rating"]} (${sitter["reviews"]})"),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      Text("${sitter["distance"]} miles"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: sitter["tags"]
                        .map<Widget>(
                          (t) => Chip(
                            label: Text(
                              t,
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor: Colors.green.shade50,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${sitter["rate"]}/hr",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  "Emergency Rate",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  sitter["eta"],
                  style: TextStyle(
                    fontSize: 12,
                    color: sitter["available"] ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
