import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  String postType = "Update";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save post to feed
              Navigator.pop(context);
            },
            child: const Text(
              "Post",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://placekitten.com/100/100",
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alex Rodriguez",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Parent",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Post text
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText:
                    "What's on your mind? Share an update, photo, or milestone...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Photo options
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text("Take Photo"),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.photo_library),
              label: const Text("Add Photo from Gallery"),
            ),
            const SizedBox(height: 16),

            // Post type
            const Text("Post Type"),
            Row(
              children: [
                ChoiceChip(
                  label: const Text("Update"),
                  selected: postType == "Update",
                  onSelected: (_) => setState(() => postType = "Update"),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("Photo"),
                  selected: postType == "Photo",
                  onSelected: (_) => setState(() => postType = "Photo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
