import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  // TODO: replace with actual contact details from website
  static const _phone = '+61 400 000 000';
  static const _email = 'hello@citytocoastsitting.com.au';
  static const _instagram = 'https://www.instagram.com/citytocoastsitting/';
  static const _facebook =
      'https://www.facebook.com/people/City-to-Coast-Baby-Pet-Sitting/61578181211909/';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Get in touch', style: textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Have questions or ready to book? Reach out and our team will help you find the perfect sitter.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _ContactRow(
          icon: Icons.phone_rounded,
          label: _phone,
          onTap: () => _launchUrl(Uri.parse('tel:$_phone')),
        ),
        const SizedBox(height: 8),
        _ContactRow(
          icon: Icons.email_rounded,
          label: _email,
          onTap: () => _launchUrl(Uri.parse('mailto:$_email')),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.facebook_rounded),
              onPressed: () => _launchUrl(Uri.parse(_facebook)),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_rounded),
              onPressed: () => _launchUrl(Uri.parse(_instagram)),
            ),
          ],
        ),
      ],
    );
  }

  static Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: avoid_print
      print('Could not launch $uri');
    }
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
