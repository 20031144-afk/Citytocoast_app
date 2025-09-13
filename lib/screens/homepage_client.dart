import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'chat_screen.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = _generateReviews();
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
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 150), // fixes overflow
          itemCount: posts.length + 1, // reviews + 1 sitters section
          itemBuilder: (context, index) {
            if (index == 3) {
              // show sitters only once after 3 reviews
              return _sittersCarousel(context, sitters);
            } else {
              final post = posts[index < 3 ? index : index - 1];
              return _buildPost(
                username: post["user"]!,
                userImg: post["img"]!,
                content: post["text"]!,
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

  // 🔹 Reviews Data
  List<Map<String, String>> _generateReviews() {
    return [
      {
        "user": "Alice",
        "img": "https://i.pravatar.cc/150?img=3",
        "text":
            "Had a wonderful experience with Jane! She was kind, punctual, and kept my baby smiling the whole evening. She even brought along some toys and read a bedtime story, which my daughter loved.",
      },
      {
        "user": "Bob",
        "img": "https://i.pravatar.cc/150?img=8",
        "text":
            "John was amazing with my dog 🐶. He took him for long walks, fed him on time, and sent me regular updates with pictures.",
      },
      {
        "user": "Clara",
        "img": "https://i.pravatar.cc/150?img=6",
        "text":
            "The sitter was okay, but arrived 15 minutes late. Service was fine after that, but I expected better punctuality since time is very important.",
      },
      {
        "user": "David",
        "img": "https://i.pravatar.cc/150?img=11",
        "text":
            "Honestly a disappointing experience. The sitter spent a lot of time on their phone and I didn’t feel like they were fully engaged with my child.",
      },
      {
        "user": "Ella",
        "img": "https://i.pravatar.cc/150?img=16",
        "text":
            "Super smooth booking experience! The app was easy to use, payment was straightforward, and the sitter was very professional.",
      },
      {
        "user": "Maya",
        "img": "https://i.pravatar.cc/150?img=31",
        "text":
            "Absolutely fantastic experience! The sitter brought such a positive energy into our home and quickly bonded with my twins. She played games, helped them with puzzles, and even cleaned up after. 🌟 Highly recommend!",
      },
      {
        "user": "Noah",
        "img": "https://i.pravatar.cc/150?img=32",
        "text":
            "The sitter did an okay job. Nothing to complain about, but nothing exceptional either. My dog was fed on time but didn’t get much playtime. ⚖️ Neutral experience.",
      },
      {
        "user": "Olivia",
        "img": "https://i.pravatar.cc/150?img=33",
        "text":
            "Terrible service ❌. The sitter left dirty dishes in the sink, ignored my instructions, and barely interacted with my child. I will not use this sitter again.",
      },
      {
        "user": "Peter",
        "img": "https://i.pravatar.cc/150?img=34",
        "text":
            "The sitter was a lifesaver! She accepted my last-minute booking request and arrived within 30 minutes. Professional, calm, and reliable. 🚀 Couldn’t be happier.",
      },
      {
        "user": "Quinn",
        "img": "https://i.pravatar.cc/150?img=35",
        "text":
            "She was polite and did what was asked, but I didn’t feel much warmth or engagement with my kids. Not terrible, but I’d prefer someone more interactive. 🤷‍♀️",
      },
      {
        "user": "Ryan",
        "img": "https://i.pravatar.cc/150?img=36",
        "text":
            "Best sitter we’ve ever had! She not only cared for our baby but also cooked a small meal for him. Going above and beyond. ⭐⭐⭐⭐⭐",
      },
      {
        "user": "Sophia",
        "img": "https://i.pravatar.cc/150?img=37",
        "text":
            "Pretty average service. My puppy was safe, but I noticed she didn’t take him out for as long as we agreed. 🐕 Neutral overall.",
      },
      {
        "user": "Tom",
        "img": "https://i.pravatar.cc/150?img=38",
        "text":
            "The sitter was late by 20 minutes and didn’t apologize. ❌ That really threw off my evening plans. Not booking again.",
      },
      {
        "user": "Uma",
        "img": "https://i.pravatar.cc/150?img=39",
        "text":
            "Excellent! The sitter arrived early, asked all the right questions, and even left me a note about how the evening went. 📝 Small touches like that mean so much!",
      },
      {
        "user": "Victor",
        "img": "https://i.pravatar.cc/150?img=40",
        "text":
            "Everything went fine, but the sitter seemed shy and didn’t communicate much. Kids were safe, though, so it worked out. ⚖️ Neutral.",
      },
      {
        "user": "Wendy",
        "img": "https://i.pravatar.cc/150?img=41",
        "text":
            "Our sitter was amazing 💖. She played music, danced with the kids, and created such a fun environment. My daughter is already asking when she’ll come back!",
      },
      {
        "user": "Xavier",
        "img": "https://i.pravatar.cc/150?img=42",
        "text":
            "Not impressed ❌. The sitter didn’t follow my feeding instructions and kept the TV on the whole time. I expected better for the price.",
      },
      {
        "user": "Yara",
        "img": "https://i.pravatar.cc/150?img=43",
        "text":
            "Great experience! She sent me regular updates and even cute photos 📸 while I was away. That level of care gave me real peace of mind.",
      },
      {
        "user": "Zane",
        "img": "https://i.pravatar.cc/150?img=44",
        "text":
            "The sitter was okay, but didn’t really engage with my teenage son. ⚖️ Neutral but safe experience, so not too bad.",
      },
      {
        "user": "Amelia",
        "img": "https://i.pravatar.cc/150?img=45",
        "text":
            "Fantastic! She managed three kids at once with no problem, handled dinner and bedtime like a pro. 👏 Couldn’t have asked for more.",
      },
      {
        "user": "Ben",
        "img": "https://i.pravatar.cc/150?img=46",
        "text":
            "She forgot to walk the dog and didn’t leave the house tidy. ❌ My expectations were not met.",
      },
      {
        "user": "Celine",
        "img": "https://i.pravatar.cc/150?img=47",
        "text":
            "Truly lovely sitter 💕. She had a calming presence and instantly made my baby feel safe. I could enjoy my evening stress-free.",
      },
      {
        "user": "Daniel",
        "img": "https://i.pravatar.cc/150?img=48",
        "text":
            "Pretty decent. The sitter did everything required but nothing extra. Safe but average ⚖️.",
      },
      {
        "user": "Eva",
        "img": "https://i.pravatar.cc/150?img=49",
        "text":
            "Hands down the best sitter we’ve hired. She helped with homework, cooked a small snack, and played board games. My kids adore her 🥰.",
      },
      {
        "user": "Felix",
        "img": "https://i.pravatar.cc/150?img=50",
        "text":
            "Unfortunately the sitter was very distracted ❌. She answered phone calls during the sitting and seemed disengaged. Not happy with the service.",
      },
    ];
  }
}
