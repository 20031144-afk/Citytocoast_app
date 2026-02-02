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
                            builder: (context) =>
                                const BookBabysitterScreen(isPetSitting: false),
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
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Babysitting Rates', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Professional care for your children. Here’s how our babysitting bookings work:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(
                child: _RateCard(
                  title: 'Standard Rate',
                  price: '\$35',
                  subtitle: 'Starting from',
                  chipText: 'Mon–Sat',
                  lines: [
                    '1–2 Kids \$35/hr',
                    '3 Kids \$40/hr',
                    '4 Kids \$45/hr',
                    '5 Kids \$50/hr',
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _RateCard(
                  title: 'Sunday Rate',
                  price: '\$45',
                  subtitle: 'Starting from',
                  chipText: 'Sunday',
                  lines: [
                    '1–2 Kids \$45/hr',
                    '3 Kids \$50/hr',
                    '4 Kids \$55/hr',
                    '5 Kids \$60/hr',
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color(0xFFF7F7F9),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'A non-refundable booking fee applies per booking. Last-minute and public '
                'holiday bookings may incur additional surcharges — please refer to the '
                'full rate sheet or contact us for details.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
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

class _RateCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final String chipText;
  final List<String> lines;

  const _RateCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.chipText,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2B47),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A2B47),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2B47),
                  ),
                ),
                Text(
                  price.replaceAll('\$', ''),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2B47),
                  ),
                ),
                Text(
                  ' /Hour',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F).withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                chipText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...lines.map(
              (l) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: Color(0xFF81C784),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF1A2B47),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
