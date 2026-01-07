import 'package:flutter/material.dart';
import 'sitter.dart';
import 'sitter_profile_page.dart';

class FeaturedSittersScreen extends StatelessWidget {
  final List<Sitter> sitters;

  const FeaturedSittersScreen({Key? key, required this.sitters})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Featured Sitters"),
        backgroundColor: const Color(0xFF6A5AE0),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sitters.length,
        separatorBuilder: (_, __) => const Divider(height: 20),
        itemBuilder: (context, index) {
          final sitter = sitters[index];
          return _sitterCard(context, sitter);
        },
      ),
    );
  }

  // dY"1 Reusable sitter card
  Widget _sitterCard(BuildContext context, Sitter sitter) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(sitter.profileImageUrl),
      ),
      title: Text(
        sitter.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        "${sitter.ratingLabel}\n${sitter.specialties.join(", ")}",
        style: const TextStyle(fontSize: 12, height: 1.4),
      ),
      trailing: Text(
        "\$${sitter.ratePerHour}/hr",
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SitterProfilePage(sitter: sitter)),
        );
      },
    );
  }
}

