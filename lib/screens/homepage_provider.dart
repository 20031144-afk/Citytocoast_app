import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final List<String> _comments = [
    "Loved the pet sitting service!",
    "The nanny was amazing with my child.",
    "Great caring service experience.",
    "WAS really a terrrible experience with that carer.",
    "Would not recommend.",
    "Friendly and professional team.",
    "Highly recommend for pet care.",
    "Excellent babysitting service!",
    "😍",
    "😡",
    "😊",
    "😞",
  ];

  // store sentiment results
  final Map<int, Map<String, dynamic>> _sentimentResults = {};

  @override
  void initState() {
    super.initState();
    _analyzeAllComments();
  }

  Future<void> _analyzeAllComments() async {
    for (int i = 0; i < _comments.length; i++) {
      await _analyzeComment(i, _comments[i]);
    }
  }

  Future<void> _analyzeComment(int index, String text) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/analyze"), // 🔗 FastAPI
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _sentimentResults[index] = {
            "sentiment": data["sentiment"],
            "compound": data["scores"]["compound"],
          };
        });
      } else {
        setState(() {
          _sentimentResults[index] = {"sentiment": "Error"};
        });
      }
    } catch (e) {
      setState(() {
        _sentimentResults[index] = {"sentiment": "Error"};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Provider Dashboard"),
        backgroundColor: Colors.purpleAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purpleAccent),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Bookings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text("Messages"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _analyzeAllComments,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final result = _sentimentResults[index];
            final sentiment = result?["sentiment"] ?? "Analyzing...";
            final compound = result?["compound"] ?? 0.0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _comments[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text("Sentiment: $sentiment"),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (compound + 1) / 2, // normalize -1 → 1 into 0 → 1
                      backgroundColor: Colors.grey[300],
                      color: compound >= 0.05
                          ? Colors.green
                          : (compound <= -0.05 ? Colors.red : Colors.orange),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
