import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  bool _loading = true;
  Map<String, dynamic> _summary = {};
  List<Map<String, dynamic>> _reviews = [];
  final String baseUrl = "http://127.0.0.1:8000";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final summaryRes = await http.get(Uri.parse("$baseUrl/summary"));
      final reviewsRes = await http.get(Uri.parse("$baseUrl/reviews"));
      if (summaryRes.statusCode == 200 && reviewsRes.statusCode == 200) {
        setState(() {
          _summary = jsonDecode(summaryRes.body);
          _reviews = List<Map<String, dynamic>>.from(
            jsonDecode(reviewsRes.body),
          );
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching dashboard: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Sentiment Pie Chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "Overall Sentiment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: _summary["positive_percent"],
                                  color: Colors.green,
                                  title: "Positive",
                                ),
                                PieChartSectionData(
                                  value: _summary["neutral_percent"],
                                  color: Colors.orange,
                                  title: "Neutral",
                                ),
                                PieChartSectionData(
                                  value: _summary["negative_percent"],
                                  color: Colors.red,
                                  title: "Negative",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Stats Cards
                Row(
                  children: [
                    _statCard(
                      "Total Reviews",
                      _summary["total_reviews"].toString(),
                      Icons.comment,
                    ),
                    _statCard(
                      "New Users",
                      _summary["new_users"].toString(),
                      Icons.person_add,
                    ),
                    _statCard(
                      "Reactions",
                      _summary["total_reactions"].toString(),
                      Icons.thumb_up,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Recent Feedbacks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._reviews.map(
                  (r) => _feedbackCard(
                    username: r["user"],
                    img: r["img"],
                    comment: r["text"],
                    sentiment: r["sentiment"],
                    score: r["scores"]["compound"],
                    date: r["date"],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.teal),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedbackCard({
    required String username,
    required String img,
    required String comment,
    required String sentiment,
    required double score,
    required String date,
  }) {
    Color color = sentiment == "positive"
        ? Colors.green
        : sentiment == "negative"
        ? Colors.red
        : Colors.orange;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(img), radius: 20),
                const SizedBox(width: 8),
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  date.split("T").first,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(comment),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (score + 1) / 2,
              color: color,
              backgroundColor: Colors.grey[300],
              minHeight: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sentiment: $sentiment", style: TextStyle(color: color)),
                Text("Score: ${score.toStringAsFixed(2)}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
