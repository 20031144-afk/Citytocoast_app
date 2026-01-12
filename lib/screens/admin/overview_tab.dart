import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 🔹 Top Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metricCard("Overall Sentiment", "76.0%", "+5.3%", Colors.green),
              _metricCard(
                "Total Reviews",
                "15,847",
                "68.2% Positive",
                Colors.blue,
              ),
              _metricCard(
                "Comments & Posts",
                "11,090",
                "8,934 comments",
                Colors.orange,
              ),
              _metricCard(
                "Alert Status",
                "2",
                "High priority alerts",
                Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 🔹 Distribution & Region
          Row(
            children: [
              Expanded(child: _sentimentDistribution()),
              const SizedBox(width: 16),
              Expanded(child: _regionalPerformance()),
            ],
          ),
          const SizedBox(height: 20),

          // 🔹 Recent Activity
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _activityMetric("247", "New Reviews", Colors.blue),
                _activityMetric("89%", "Positive Sentiment", Colors.green),
                _activityMetric("3", "New Alerts", Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String title, String value, String subtitle, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(subtitle, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _sentimentDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Sentiment Distribution",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 68.2,
                    color: Colors.green,
                    title: "Positive",
                  ),
                  PieChartSectionData(
                    value: 22.1,
                    color: Colors.orange,
                    title: "Neutral",
                  ),
                  PieChartSectionData(
                    value: 9.7,
                    color: Colors.red,
                    title: "Negative",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _regionalPerformance() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Regional Performance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _regionRow("North District", 78.0, 23),
          _regionRow("South District", 74.0, 34),
          _regionRow("East District", 81.0, 18),
          _regionRow("West District", 72.0, 28),
          _regionRow("Central District", 83.0, 15),
        ],
      ),
    );
  }
}

class _regionRow extends StatelessWidget {
  final String region;
  final double sentiment;
  final int complaints;
  const _regionRow(this.region, this.sentiment, this.complaints, {Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$region – ${sentiment.toStringAsFixed(1)}%"),
          LinearProgressIndicator(
            value: sentiment / 100,
            color: sentiment > 75 ? Colors.green : Colors.orange,
            backgroundColor: Colors.grey.shade200,
          ),
          Text(
            "$complaints complaints",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _activityMetric extends StatelessWidget {
  final String value, label;
  final Color color;
  const _activityMetric(this.value, this.label, this.color, {Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label),
      ],
    );
  }
}
