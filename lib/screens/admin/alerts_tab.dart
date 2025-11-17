import 'package:flutter/material.dart';

class AlertsTab extends StatelessWidget {
  const AlertsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        "name": "John Smith",
        "message": "Sudden increase in negative reviews",
        "priority": "high",
        "time": "2 hours ago",
      },
      {
        "name": "Emma Davis",
        "message": "Rating dropped below 4.0",
        "priority": "medium",
        "time": "5 hours ago",
      },
      {
        "name": "Robert Brown",
        "message": "Multiple complaints about punctuality",
        "priority": "high",
        "time": "1 day ago",
      },
      {
        "name": "Anna Wilson",
        "message": "Excellent feedback streak",
        "priority": "low",
        "time": "2 days ago",
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ...alerts.map((a) => _alertCard(a)).toList(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _priorityBox("High Priority", "2", Colors.red),
              _priorityBox("Medium Priority", "1", Colors.orange),
              _priorityBox("Low Priority", "1", Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _alertCard(Map<String, dynamic> alert) {
    Color color;
    switch (alert["priority"]) {
      case "high":
        color = Colors.red;
        break;
      case "medium":
        color = Colors.orange;
        break;
      case "low":
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(alert["message"]),
                Text(
                  alert["time"],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alert["priority"],
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _priorityBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _priorityBox(this.label, this.value, this.color, {Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color),
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
            Text(label),
          ],
        ),
      ),
    );
  }
}
