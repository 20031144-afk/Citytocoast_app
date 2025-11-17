import 'package:flutter/material.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "title": "Babysitting Reviews",
        "positive": 874,
        "neutral": 234,
        "negative": 89,
      },
      {
        "title": "Pet Sitting Reviews",
        "positive": 692,
        "neutral": 198,
        "negative": 67,
      },
      {
        "title": "Emergency Services",
        "positive": 156,
        "neutral": 45,
        "negative": 23,
      },
      {
        "title": "Community Posts",
        "positive": 445,
        "neutral": 123,
        "negative": 34,
      },
      {
        "title": "General Comments",
        "positive": 1234,
        "neutral": 456,
        "negative": 178,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final c = categories[i];
        final total =
            (c["positive"] as int) +
            (c["neutral"] as int) +
            (c["negative"] as int);
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c["title"] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (c["positive"] as int) / total,
                color: Colors.green,
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${c["positive"]} Positive",
                    style: const TextStyle(color: Colors.green),
                  ),
                  Text(
                    "${c["neutral"]} Neutral",
                    style: const TextStyle(color: Colors.orange),
                  ),
                  Text(
                    "${c["negative"]} Negative",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Status: Good",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }
}
