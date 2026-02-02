import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Care you can truly trust',
              // TODO: use real tagline from website
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Reliable babysitting & pet sitting across Brisbane, the Gold Coast and Sunshine Coast.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // You could navigate to Families tab
                      DefaultTabController.of(context);
                    },
                    child: const Text('Book a sitter'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to Sitters tab
                    },
                    child: const Text('Become a sitter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
