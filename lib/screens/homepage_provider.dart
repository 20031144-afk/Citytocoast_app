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
  final String baseUrl = "http://10.0.2.2:8000"; // your backend

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
                // 📊 Sentiment Pie Chart
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
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: _buildPieSections(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildLegend(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 📌 Stats Cards
                Row(
                  children: [
                    _statCard(
                      "Total Reviews",
                      (_summary["total_reviews"] ?? 0).toString(),
                      Icons.comment,
                    ),
                    _statCard(
                      "New Users",
                      (_summary["new_users"] ?? 0).toString(),
                      Icons.person_add,
                    ),
                    _statCard(
                      "Reactions",
                      (_summary["total_reactions"] ?? 0).toString(),
                      Icons.thumb_up,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 💬 Feedback list
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
                    score: (r["scores"]["compound"] as num).toDouble(),
                    date: r["date"],
                  ),
                ),
              ],
            ),
    );
  }

  /// 🔹 Build Pie Chart Sections with Labels
  List<PieChartSectionData> _buildPieSections() {
    final pos = (_summary["positive_percent"] ?? 0).toDouble();
    final neu = (_summary["neutral_percent"] ?? 0).toDouble();
    final neg = (_summary["negative_percent"] ?? 0).toDouble();

    return [
      PieChartSectionData(
        value: pos,
        color: Colors.green,
        title: "${pos.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: neu,
        color: Colors.orange,
        title: "${neu.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: neg,
        color: Colors.red,
        title: "${neg.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  /// 🔹 Build Pie Chart Legend
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _LegendItem(color: Colors.green, label: "Positive"),
        SizedBox(width: 12),
        _LegendItem(color: Colors.orange, label: "Neutral"),
        SizedBox(width: 12),
        _LegendItem(color: Colors.red, label: "Negative"),
      ],
    );
  }

  /// 🔹 Small stats card
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

  /// 🔹 Feedback Card
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
              value: (score + 1) / 2, // normalize -1..1 → 0..1
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

/// 🔹 Legend item widget
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
