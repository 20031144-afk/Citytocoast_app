import 'package:flutter/material.dart';

class SittersTab extends StatelessWidget {
  const SittersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sitters = [
      {
        "name": "Sarah Johnson",
        "category": "Babysitting",
        "reviews": 127,
        "rating": 4.9,
        "sentiment": 94,
      },
      {
        "name": "Mike Chen",
        "category": "Pet Sitting",
        "reviews": 89,
        "rating": 4.8,
        "sentiment": 91,
      },
      {
        "name": "Lisa Wang",
        "category": "Babysitting",
        "reviews": 156,
        "rating": 4.9,
        "sentiment": 89,
      },
      {
        "name": "James Wilson",
        "category": "Pet Sitting",
        "reviews": 203,
        "rating": 4.7,
        "sentiment": 87,
      },
      {
        "name": "Maria Santos",
        "category": "Emergency",
        "reviews": 178,
        "rating": 4.8,
        "sentiment": 85,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTable(
        border: TableBorder.all(color: Colors.grey.shade300, width: 0.5),
        columns: const [
          DataColumn(label: Text("Sitter")),
          DataColumn(label: Text("Category")),
          DataColumn(label: Text("Reviews")),
          DataColumn(label: Text("Rating")),
          DataColumn(label: Text("Sentiment")),
          DataColumn(label: Text("Status")),
        ],
        rows: sitters.map((s) {
          return DataRow(
            cells: [
              DataCell(Text(s["name"].toString())),
              DataCell(Text(s["category"].toString())),
              DataCell(Text(s["reviews"].toString())),
              DataCell(Text(s["rating"].toString())),
              DataCell(Text("${s["sentiment"]}%")),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Excellent",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
