import 'package:flutter/material.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final testimonials = [
      // TODO: replace with real testimonials from website
      {
        'quote':
            'Our sitter was incredible – the kids loved her and we felt completely at ease.',
        'name': 'Sarah, Brisbane',
      },
      {
        'quote':
            'Such a smooth process from enquiry to booking. Highly recommend.',
        'name': 'Matt, Gold Coast',
      },
      {
        'quote':
            'They took amazing care of our dog while we were away for the weekend.',
        'name': 'Jess, Sunshine Coast',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What families say', style: textTheme.headlineMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final t = testimonials[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '“${t['quote']}”',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(t['name']!, style: textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
