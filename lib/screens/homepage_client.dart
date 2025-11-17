import 'package:flutter/material.dart';
import 'sitter.dart';
import 'sitter_profile_page.dart';
import 'FeaturedSittersScreen.dart';
import 'sitters_list.dart'; // now returns List<Sitter>

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String selectedCategory = "both";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // 🔹 Filter sitters by category + search query
    final filteredSitters = sitterList.where((sitter) {
      final matchesCategory =
          selectedCategory == "both" || sitter.tags.contains(selectedCategory);
      final matchesSearch = sitter.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Gradient Header
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
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hello, Ashma!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
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

                    // Search bar
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

              // 🔹 Category Toggle
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

              // 🔹 Featured Sitters Section
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

              // 🔹 Sitters List (show top 3 only)
              ...filteredSitters.take(3).map((s) => _sitterCard(context, s)),

              const SizedBox(height: 20),

              // 🔹 Quick Actions Section
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
              // Admin Dashboard
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

  // 🔹 Category Button
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

  // 🔹 Sitter Card (Clickable)
  Widget _sitterCard(BuildContext context, Sitter sitter) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(sitter.img),
      ),
      title: Text(
        sitter.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "⭐ ${sitter.rating} (${sitter.reviews} reviews) • ${sitter.distance} miles\n${sitter.specialties.join(", ")}",
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

  // 🔹 Quick Action Card
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
