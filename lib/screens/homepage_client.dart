import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'chat_screen.dart';
import '../services/review_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final ReviewService _reviewService = ReviewService();
  List<Map<String, dynamic>> posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final data = await _reviewService.fetchReviews();
      setState(() {
        posts = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final sitters = _generateSitters();

    return Scaffold(
      appBar: AppBar(title: const Text("City to Coast"), centerTitle: true),

      // 🔹 Drawer with Book Now
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Client User"),
              accountEmail: Text("client@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=15",
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("My Bookings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text("Book Now"),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
          ],
        ),
      ),

      // 🔹 Feed with reviews + sitters once
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 150),
                itemCount: posts.length + 1, // reviews + 1 sitters section
                itemBuilder: (context, index) {
                  if (index == 3) {
                    // show sitters only once after 3 reviews
                    return _sittersCarousel(context, sitters);
                  } else {
                    final post = posts[index < 3 ? index : index - 1];
                    return _buildPost(
                      username: post["user"] ?? "Anonymous",
                      userImg: post["img"] ?? "https://i.pravatar.cc/150?img=1",
                      content: post["text"] ?? "",
                    );
                  }
                },
              ),
      ),

      // 🔹 Floating chat button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreen()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  // 🔹 Feed Post
  Widget _buildPost({
    required String username,
    required String userImg,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundImage: NetworkImage(userImg), radius: 25),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Sitters carousel
  Widget _sittersCarousel(
    BuildContext context,
    List<Map<String, dynamic>> sitters,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Sitters Nearby",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sitters.length,
            itemBuilder: (context, index) {
              final s = sitters[index];
              return _buildSitterCard(
                name: s["name"],
                rate: s["rate"],
                rating: s["rating"],
                available: s["available"],
                img: s["img"],
                onBook: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingScreen()),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // 🔹 Sitter card
  Widget _buildSitterCard({
    required String name,
    required int rate,
    required double rating,
    required bool available,
    required String img,
    required VoidCallback onBook,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 40, backgroundImage: NetworkImage(img)),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(
                    rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "\$$rate/hr",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                available ? "Available" : "Unavailable",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: available ? Colors.green : Colors.red,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: available ? onBook : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text("Book Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Sitters Data
  List<Map<String, dynamic>> _generateSitters() {
    return [
      {
        "name": "Jane Doe",
        "rate": 36,
        "rating": 4.8,
        "available": true,
        "img": "https://i.pravatar.cc/150?img=12",
      },
      {
        "name": "John Smith",
        "rate": 38,
        "rating": 4.6,
        "available": false,
        "img": "https://i.pravatar.cc/150?img=14",
      },
      {
        "name": "Emma Wilson",
        "rate": 45,
        "rating": 4.9,
        "available": true,
        "img": "https://i.pravatar.cc/150?img=22",
      },
      {
        "name": "Liam Brown",
        "rate": 23,
        "rating": 4.4,
        "available": true,
        "img": "https://i.pravatar.cc/150?img=25",
      },
      {
        "name": "Sophia Davis",
        "rate": 26,
        "rating": 4.7,
        "available": false,
        "img": "https://i.pravatar.cc/150?img=28",
      },
      {
        "name": "Ethan Miller",
        "rate": 30,
        "rating": 4.5,
        "available": true,
        "img": "https://i.pravatar.cc/150?img=30",
      },
    ];
  }
}
