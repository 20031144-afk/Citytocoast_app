import 'package:flutter/material.dart';
import 'book_babysitter_screen.dart';

class BabysittingScreen extends StatelessWidget {
  const BabysittingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Babysitting Services')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _BabysittingHeroSection(),
              _BabysittingIntroSection(),
              _BabysittingApproachSection(),
              _BabysittingRatesSection(),
              _AreasWeCoverSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- HERO SECTION ----------------

class _BabysittingHeroSection extends StatelessWidget {
  const _BabysittingHeroSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.40,
      child: Row(
        children: [
          // LEFT: text
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Babysitting Services',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Brisbane, Gold Coast\n& Sunshine Coast',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFFFC94A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BookBabysitterScreen(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Prototype: booking form not connected yet.',
                            ),
                          ),
                        );
                      },
                      child: const Text('Book a Babysitter'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // RIGHT: hero image
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
              ),
              child: Image.asset(
                'assets/icons/img4.jpg',
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- INTRO + REQUIREMENTS ----------------

class _BabysittingIntroSection extends StatelessWidget {
  const _BabysittingIntroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'At City to Coast, we understand how important it is to feel completely '
            'confident when leaving your children in someone else’s care. Our babysitting '
            'services combine professional standards with a nurturing, family-first approach '
            'so you can step away knowing your little ones are safe, happy and well cared for.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Whether you need a few hours for a night out, short-stay care while you work, '
            'or support during school holidays, our babysitters create a safe and positive '
            'environment. From story time and play to homework help and bedtime routines, '
            'we’re here to make sure your children feel secure and cared for — just like they '
            'would at home.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Text(
            'Every one of our sitters is carefully selected and must meet strict requirements, including:',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const _BulletPoint('A valid Police Check & Blue Card'),
          const _BulletPoint(
            'First Aid & CPR Certification (HLTAID012 – current)',
          ),
          const _BulletPoint('A current ABN'),
          const _BulletPoint(
            'Access to a reliable, insured vehicle and mobile phone',
          ),
          const _BulletPoint(
            'A warm, clear communicator with a genuinely nurturing approach',
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BookBabysitterScreen(),
                  ),
                );
              },
              child: const Text('Book a Babysitter'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- APPROACH SECTION ----------------

class _BabysittingApproachSection extends StatelessWidget {
  const _BabysittingApproachSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F7F9),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'City to Coast Approach to Babysitting',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const _BulletPoint(
            'From booking to bedtime, we keep communication clear so you always know '
            'how your children are going.',
          ),
          const _BulletPoint(
            'We follow your family’s routines as closely as possible — meals, bath time, '
            'bedtime, and favourite comfort items.',
          ),
          const _BulletPoint(
            'We prioritise play, stories and conversation that help your children feel '
            'comfortable and connected.',
          ),
          const _BulletPoint(
            'You return home to a calm house and clear notes about how the time together went.',
          ),
        ],
      ),
    );
  }
}

/// ---------------- RATES SECTION ----------------

class _BabysittingRatesSection extends StatelessWidget {
  const _BabysittingRatesSection();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace example amounts with the real rates from the website
    final rates = [
      '1-2 kids – \$35 per hour',
      '3 kids – \$40 per hour',
      '4 kids – \$45 per hour',
      '5 kids – \$50 per hour',
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Babysitting Rates',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...rates.map(
                    (r) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '• $r',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'A non-refundable booking fee applies per booking. Last-minute and public '
                    'holiday bookings may incur additional surcharges — please refer to the '
                    'full rate sheet or contact us for details.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BookBabysitterScreen(),
                  ),
                );
              },
              child: const Text('Book a Babysitter'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- AREAS WE COVER SECTION ----------------

class _AreasWeCoverSection extends StatelessWidget {
  const _AreasWeCoverSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: const Color(0xFFF7F7F9),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('Areas we cover', style: textTheme.headlineMedium),
          ),
          const SizedBox(height: 16),
          Column(
            children: const [
              _AreaCard(
                title: 'Brisbane',
                description: 'Servicing from Caboolture to Beenleigh',
              ),
              SizedBox(height: 12),
              _AreaCard(
                title: 'Gold Coast',
                description: 'Servicing from Stapylton to Coolangatta',
              ),
              SizedBox(height: 12),
              _AreaCard(
                title: 'Sunshine Coast',
                description: 'Servicing from Pelican Waters to Noosa Nth Shore',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final String title;
  final String description;

  const _AreaCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(description, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- SMALL REUSABLE WIDGETS ----------------

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
