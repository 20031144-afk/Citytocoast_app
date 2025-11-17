import 'package:flutter/material.dart';
import 'sitter.dart';
import 'booking_screen.dart';

class SitterProfilePage extends StatelessWidget {
  final Sitter sitter;

  const SitterProfilePage({Key? key, required this.sitter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sitter.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header row with avatar + info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(sitter.img),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                sitter.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Verified",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "⭐ ${sitter.rating} (${sitter.reviews} reviews)",
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "📍 ${sitter.distance} miles away",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔹 Price
                Text(
                  "\$${sitter.ratePerHour}/hour",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 About Section
                const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  sitter.bio,
                  style: const TextStyle(color: Colors.black87, height: 1.4),
                ),

                const SizedBox(height: 20),

                // 🔹 Experience
                const Text(
                  "Experience",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text(
                  "8 years of professional experience", // You could extend sitter model with yearsOfExperience
                  style: TextStyle(color: Colors.black87),
                ),

                const SizedBox(height: 20),

                // 🔹 Specialties
                const Text(
                  "Specialties",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: sitter.specialties
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 20),

                // 🔹 Availability
                const Text(
                  "Availability",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: sitter.availability
                      .map(
                        (slot) => Chip(
                          label: Text(slot),
                          backgroundColor: Colors.grey.shade100,
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 20),

                // 🔹 Bottom Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.message),
                        label: const Text("Message"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.call),
                        label: const Text("Call"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Book Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(sitter: sitter),
                        ),
                      );
                    },
                    child: const Text(
                      "Book This Sitter",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
