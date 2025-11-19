import 'package:flutter/material.dart';

class ServiceAreasSection extends StatelessWidget {
  const ServiceAreasSection({super.key});

  @override
  Widget build(BuildContext context) {
    final areas = const [
      'Brisbane',
      'Gold Coast',
      'Sunshine Coast',
      // Add any others that are on the website
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service areas',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: areas.map((a) => Chip(label: Text(a))).toList(),
        ),
      ],
    );
  }
}
