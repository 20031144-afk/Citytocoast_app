import 'package:flutter/material.dart';
import 'create_post_screen.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({Key? key}) : super(key: key);

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  // 🔹 Mock posts (4 with images, 6 text only)
  final List<Map<String, dynamic>> posts = [
    {
      "user": "Sarah Johnson",
      "role": "Sitter",
      "time": "1 hour ago",
      "img": "https://i.pravatar.cc/150?img=14",
      "text":
          "Such a fun day babysitting Emma today! Tea party and storytime. 💕",
      "image": "assets/images/assets1.jpg",
      "likes": 15,
      "comments": [
        {"user": "Emma's Mom", "text": "Thank you Sarah! Emma loved it ❤️"},
        {"user": "Alex", "text": "So sweet!"},
      ],
    },
    {
      "user": "Mike Chen",
      "role": "Sitter",
      "time": "2 hours ago",
      "text": "Took Max on a walk and he’s already napping 🐕",
      "image": null,
      "likes": 8,
      "comments": [
        {"user": "Owner", "text": "Thanks Mike! Max looks so happy."},
      ],
    },
    {
      "user": "Lisa Wang",
      "role": "Parent",
      "time": "3 hours ago",
      "text": "Lucy had a wonderful weekend with Maria! Highly recommend ⭐⭐⭐⭐⭐",
      "image": "assets/images/assets2.jpg",
      "likes": 10,
      "comments": [
        {"user": "Maria", "text": "Thank you Lisa, Lucy was lovely!"},
        {"user": "Sarah", "text": "Maria is amazing 👏"},
      ],
    },
    {
      "user": "Alex Rodriguez",
      "role": "Parent",
      "time": "6 hours ago",
      "text": "Can’t thank Sarah enough for helping on such short notice 🙏",
      "image": null,
      "likes": 6,
      "comments": [],
    },
    {
      "user": "Maria Santos",
      "role": "Sitter",
      "time": "Yesterday",
      "text": "Emergency babysitting done ✅ Little Ella was an angel!",
      "image": "assets/images/assets3.jpg",
      "likes": 20,
      "comments": [
        {"user": "Ella’s Dad", "text": "We appreciate you Maria!"},
      ],
    },
    {
      "user": "James Wilson",
      "role": "Sitter",
      "time": "Yesterday",
      "text": "Pet sitting Rocky today. He wouldn’t stop wagging his tail 🐾",
      "image": null,
      "likes": 9,
      "comments": [],
    },
    {
      "user": "Emma Davis",
      "role": "Parent",
      "time": "2 days ago",
      "text": "Shoutout to Mike for being so reliable and punctual 👏",
      "image": "assets/images/assets4.jpg",
      "likes": 18,
      "comments": [
        {"user": "Mike", "text": "Thank you Emma, always happy to help!"},
      ],
    },
    {
      "user": "Robert Brown",
      "role": "Parent",
      "time": "2 days ago",
      "text": "We need more amazing sitters like Lisa in this community ❤️",
      "image": null,
      "likes": 7,
      "comments": [
        {"user": "Lisa", "text": "Thank you Robert!"},
      ],
    },
    {
      "user": "Anna Wilson",
      "role": "Sitter",
      "time": "3 days ago",
      "text":
          "Loved spending time with the kids today, lots of arts & crafts 🎨",
      "image": null,
      "likes": 12,
      "comments": [],
    },
    {
      "user": "John Smith",
      "role": "Parent",
      "time": "3 days ago",
      "text": "Huge thanks to the whole community for being so supportive 🙌",
      "image": null,
      "likes": 5,
      "comments": [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Feed"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // 🔹 Share box
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/asset1.jpg"),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text("Share an update or photo...")),
                ],
              ),
            ),
          ),

          // 🔹 Posts
          ...posts.map((post) => _buildPost(post)).toList(),
        ],
      ),
    );
  }

  Widget _buildPost(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Post header
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage("assets/images/asset2.jpg"),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post["user"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        post["time"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          post["role"],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Text
          Text(post["text"]),
          const SizedBox(height: 8),

          // 🔹 Image if available
          if (post["image"] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(post["image"], fit: BoxFit.cover),
            ),

          const SizedBox(height: 10),

          // 🔹 Likes and Comments
          Row(
            children: [
              Icon(Icons.favorite, size: 18, color: Colors.red.shade400),
              const SizedBox(width: 4),
              Text("${post["likes"]}"),
              const SizedBox(width: 20),
              const Icon(Icons.comment, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text("${post["comments"].length}"),
              const Spacer(),
              const Icon(Icons.share, size: 18, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Comments
          ...post["comments"].map<Widget>(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage("assets/images/asset3.jpg"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("${c["user"]}: ${c["text"]}"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Add comment box
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage("assets/images/asset4.jpg"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
