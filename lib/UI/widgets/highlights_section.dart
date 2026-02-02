import 'package:flutter/material.dart';

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Why families choose us', style: textTheme.headlineMedium),
        const SizedBox(height: 12),
        Column(
          children: const [
            _HighlightRow(
              icon: Icons.verified_user_rounded,
              title: 'Vetted, trusted sitters',
              description:
                  'All sitters are carefully screened with references and checks.',
            ),
            _HighlightRow(
              icon: Icons.schedule_rounded,
              title: 'Flexible bookings',
              description:
                  'Choose the dates, times and support that fit your family.',
            ),
            _HighlightRow(
              icon: Icons.favorite_rounded,
              title: 'Care that feels like family',
              description:
                  'We match you with sitters who genuinely care about your kids and pets.',
            ),
          ],
        ),
      ],
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _HighlightRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
