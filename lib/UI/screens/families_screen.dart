import 'package:flutter/material.dart';

class FamiliesScreen extends StatelessWidget {
  const FamiliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('For Families'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Trusted care for your little ones & fur-babies',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              // TODO: copy actual text from website
              'City to Coast Sitting connects you with carefully vetted babysitters and pet sitters across Brisbane, the Gold Coast and Sunshine Coast. '
              'Whether you need a date night, help during school holidays or support while you travel, we make booking simple and stress-free.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Request a booking',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'What support do you need?',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: hook to backend / email
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Prototype only – form not submitted.'),
                  ),
                );
              },
              child: const Text('Send enquiry'),
            ),
          ],
        ),
      ),
    );
  }
}
