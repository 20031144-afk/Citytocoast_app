import 'package:citytocoast_app/services/firestore_service.dart';
import 'package:citytocoast_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:citytocoast_app/dev/seed_sitters.dart';
import 'sitter.dart';
import 'sitter_profile_page.dart';
import 'FeaturedSittersScreen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String selectedCategory = "both";
  String? selectedAvailabilitySlot;
  String searchQuery = "";
  String _firstName = "Hello!";

  // ƒo. Firestore Service
  final FirestoreService _firestoreService = FirestoreService();

  // ƒo. Sitters coming from Firestore
  List<Sitter> firestoreSitters = [];

  // ƒo. Load sitters when screen opens
  @override
  void initState() {
    super.initState();
    _listenToUser();
    _loadFirestoreSitters();
  }

  void _listenToUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _firestoreService.userStream(uid).listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      final name = data?['firstName']?.toString().trim();
      if (!mounted) return;
      setState(() {
        _firstName = (name != null && name.isNotEmpty)
            ? "Hello, $name!"
            : "Hello!";
      });
    });
  }

  // ƒo. API Call Function (Modified for Auto-Seeding)
  Future<void> _loadFirestoreSitters() async {
    // dY"1 Ensure seeded sitters exist in debug mode
    if (kDebugMode) {
      await seedSitters(overwrite: false);
    }

    var sitters = await _firestoreService.fetchSitters();

    if (kDebugMode) {
      debugPrint('📍 Loaded ${sitters.length} sitters from Firestore');
      for (var s in sitters) {
        debugPrint('  - ${s.name} (${s.id})');
      }
    }

    if (mounted) {
      setState(() {
        firestoreSitters = sitters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // dY"1 Use only Firebase sitters (single source of truth)
    final filteredSitters = firestoreSitters.where((sitter) {
      final matchesCategory = selectedCategory == "both"
          ? true
          : (selectedCategory == "baby")
          ? sitter.careTypes.contains("baby") &&
                !sitter.careTypes.contains("pet")
          : sitter.careTypes.contains("pet") &&
                !sitter.careTypes.contains("baby");
      sitter.careTypes.contains(selectedCategory);
      final matchesAvailability = selectedAvailabilitySlot == null
          ? sitter.isAvailable
          : sitter.isAvailable &&
                sitter.availabilitySlots.any(
                  (slot) => slot.slots.contains(selectedAvailabilitySlot),
                );
      final matchesSearch = sitter.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch && matchesAvailability;
    }).toList();

    return Scaffold(
      floatingActionButton: null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // dY"1 Gradient Header (NO CHANGES)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF5ED0FB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _firstName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            AuthService().logout();
                            Navigator.pushReplacementNamed(context, "/");
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Find trusted sitters near you",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Search for sitters...",
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          setState(() => searchQuery = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // dY"1 Category Toggle (NO CHANGES)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _categoryButton("Baby Care", "baby"),
                    _categoryButton("Pet Care", "pet"),
                    _categoryButton("Both", "both"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // dY"1 Featured Sitters (NO UI changes)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Featured Sitters",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FeaturedSittersScreen(sitters: filteredSitters),
                          ),
                        );
                      },
                      child: const Text(
                        "See All",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // dY"1 Sitters List (Limit to 5)
              ...filteredSitters.take(5).map((s) => _sitterCard(context, s)),

              const SizedBox(height: 20),

              // dY"1 Quick Actions (NO CHANGES)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _quickAction(
                      context,
                      icon: Icons.timer,
                      text: "Emergency Booking",
                      route: "/emergencyBooking",
                    ),
                    _quickAction(
                      context,
                      icon: Icons.favorite,
                      text: "My Favorites",
                      route: "/favorites",
                    ),
                    _quickAction(
                      context,
                      icon: Icons.forum,
                      text: "Community Feed",
                      route: "/communityFeed",
                    ),
                    _quickAction(
                      context,
                      icon: Icons.book,
                      text: "My Bookings",
                      route: "/myBookings",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // dY"1 Admin Dashboard
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/adminDashboard');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.admin_panel_settings, color: Colors.grey),
                      SizedBox(width: 6),
                      Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // dY"1 Category Button
  Widget _categoryButton(String text, String value) {
    final isSelected = selectedCategory == value;
    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // dY"1 Sitter Card
  Widget _sitterCard(BuildContext context, Sitter sitter) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(sitter.profileImageUrl),
      ),
      title: Text(
        sitter.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
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

  // dY"1 Quick Action Card
  Widget _quickAction(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}
