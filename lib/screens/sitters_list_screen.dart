import 'package:flutter/material.dart';
import 'booking_screen.dart';

class SittersListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> sitters;

  const SittersListScreen({super.key, required this.sitters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose a Sitter")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sitters.length,
        itemBuilder: (context, index) {
          final s = sitters[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(s["img"]),
                radius: 28,
              ),
              title: Text(
                s["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("\$${s["rate"]}/hr • ⭐ ${s["rating"]}"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(
                        sitterName: s["name"],
                        sitterRate: s["rate"],
                        sitterImg: s["img"],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Book"),
              ),
            ),
          );
        },
      ),
    );
  }
}
