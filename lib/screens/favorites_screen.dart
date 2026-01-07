import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:citytocoast_app/screens/sitter_profile_page.dart';
import 'package:citytocoast_app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sitter.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to view favorites")),
      );
    }
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites"), centerTitle: true),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getFavoritesStream(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No favorites yet",
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final data = favorites[index];
              // Reconstruct a minimal Sitter object for the profile page
              final sitter = Sitter(
                id: data['id'],
                name: data['name'] ?? '',
                bio: '',
                contactNumber: '',
                suburb: data['suburb'] ?? '',
                careTypes: Sitter.asStringList(data['careTypes']),
                services: const [],
                specialties: const [],
                availabilitySlots: const [],
                availability: const [],
                ratePerHour: (data['ratePerHour'] is num)
                    ? (data['ratePerHour'] as num).toDouble()
                    : 0.0,
                ratingAvg: (data['ratingAvg'] is num)
                    ? (data['ratingAvg'] as num).toDouble()
                    : 0.0,
                ratingCount: 0,
                isAvailable: true,
                profileImageUrl: data['profileImageUrl'] ?? '',
                galleryImageUrls: const [],
                location: const GeoPoint(0, 0),
              );

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SitterProfilePage(sitter: sitter),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(sitter.profileImageUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sitter.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    sitter.ratingAvg.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "\$${sitter.ratePerHour.toStringAsFixed(0)}/hr",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
