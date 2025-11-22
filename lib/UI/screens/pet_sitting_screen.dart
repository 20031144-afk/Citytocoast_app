import 'package:flutter/material.dart';
import 'book_petsitter_screen.dart';

class PetSittingScreen extends StatelessWidget {
  const PetSittingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Sitting Services')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _PetSittingHeroSection(),
              _PetApproachSection(),
              _WhatIsPetSittingSection(),
              _GetStartedAndRatesSection(),
              _WhyFamiliesChooseUsSection(),
              _PetAreasWeCoverSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- HERO SECTION ----------------

class _PetSittingHeroSection extends StatelessWidget {
  const _PetSittingHeroSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        height: size.height * 0.42,
        child: Row(
          children: [
            // LEFT: text
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brisbane, Gold Coast & Sunshine Coast',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 255, 140, 74),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pet Sitting Services',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'At City to Coast, we know pets are part of the family too. '
                      'Whether you’re working late, away for the weekend, or travelling further afield, '
                      'our pet sitting services make sure your furry friends feel safe, loved and cared for '
                      'in their own home.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BookPetsitterScreen(),
                          ),
                        );
                      },
                      child: const Text('Book a Pet Sitter'),
                    ),
                  ],
                ),
              ),
            ),

            // RIGHT: hero image
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/icons/img5.jpg',
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- APPROACH SECTION ----------------

class _PetApproachSection extends StatelessWidget {
  const _PetApproachSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFFF7F7F9),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Lifelong advocates for animals?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFFFC94A),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'City to Coast Approach to Pet Sitting',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'At City to Coast, we believe pets thrive best when they’re cared for in their own home, '
            'surrounded by familiar sights, smells, and routines. Our approach to pet sitting is built '
            'on trust, compassion and professionalism — so your pets feel secure and loved while you’re away.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// ---------------- WHAT IS PET SITTING SECTION ----------------

class _WhatIsPetSittingSection extends StatelessWidget {
  const _WhatIsPetSittingSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // Two-column layout stacked on mobile
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What is Pet Sitting?',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pet sitting with City to Coast is short-term care designed to suit your needs — '
                      'with a minimum booking of 3 hours. You can also request overnight stays if you '
                      'need to be away longer.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our sitters provide more than just feeding and check-ins. We focus on keeping your '
                      'pets happy and comfortable with:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    const _BulletPoint('Feeding and fresh water'),
                    const _BulletPoint('Walks, playtime and enrichment'),
                    const _BulletPoint('Photos and videos sent to owners'),
                    const _BulletPoint(
                      'Administering basic medications (if required)',
                    ),
                    const _BulletPoint(
                      'Plenty of cuddles, companionship and updates for you',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/icons/img6.jpg',
                    fit: BoxFit.cover,
                    height: 220,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/icons/img7.jpg',
                    fit: BoxFit.cover,
                    height: 220,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How do I know it’s right for me?',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pet sitting is ideal if you:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    const _BulletPoint(
                      'Want short-term care (3 hours minimum) or the option of an overnight stay',
                    ),
                    const _BulletPoint(
                      'Prefer your pets remain at home rather than boarding elsewhere',
                    ),
                    const _BulletPoint(
                      'Have animals who thrive on routine or get anxious in new environments',
                    ),
                    const _BulletPoint(
                      'Need flexible, reliable support that fits around your schedule',
                    ),
                    const _BulletPoint(
                      'Appreciate regular updates, photos and peace of mind while you’re away',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------------- GET STARTED & RATES SECTION ----------------

class _GetStartedAndRatesSection extends StatelessWidget {
  const _GetStartedAndRatesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Get started band
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Get started and Book a Sitter',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BookPetsitterScreen(),
                        ),
                      );
                    },
                    child: const Text('Book a Pet Sitter'),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Please note block
        Container(
          color: const Color(0xFFF7F7F9),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Text('Please note:', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'All bookings incur a booking fee that is to be paid to start the process of finding a sitter.\n'
                'The hourly rate is to be paid directly to your sitter on the day.\n'
                'The booking fee is non-refundable and is paid prior to searching for a sitter.\n'
                'Cancellations can be made up to 3 hours prior to the booking start time to avoid a cancellation fee.\n'
                'Maximum of 5 pets per sitter.\n'
                'Please contact us for special rates on Public Holidays.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // Rates
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Standard Pet Sitting Rates',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Caring for your pets should be simple and stress-free. Here’s how our bookings work:',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                'Each booking has a minimum of 3 hours to make sure your pets receive proper attention and care.',
              ),
              const _BulletPoint(
                'A non-refundable booking fee is required before we begin searching for the right sitter for you.',
              ),
              const _BulletPoint(
                'The sitter’s hourly rate is paid directly on the day of service.',
              ),
              const _BulletPoint(
                'If your plans change, you may cancel up to 3 hours before the scheduled start time without incurring a cancellation fee.',
              ),

              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(
                    child: _RateCard(
                      title: 'Standard Rate',
                      price: '\$30',
                      subtitle: 'Starting from',
                      chipText: 'Mon–Sat',
                      lines: [
                        '1–2 Pets \$30/hr',
                        '3 Pets \$35/hr',
                        '4 Pets \$40/hr',
                        '5 Pets \$45/hr',
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _RateCard(
                      title: 'Sunday Rate',
                      price: '\$35',
                      subtitle: 'Starting from',
                      chipText: 'Sunday',
                      lines: [
                        '1–2 Pets \$35/hr',
                        '3 Pets \$40/hr',
                        '4 Pets \$45/hr',
                        '5 Pets \$50/hr',
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'For Overnight Sitters, Please Note:',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(child: _OvernightCard()),
                  SizedBox(width: 12),
                  Expanded(child: _OvernightNotes()),
                ],
              ),
            ],
          ),
        ),
      ],
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
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(subtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(price, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Chip(label: Text(chipText)),
            const SizedBox(height: 8),
            ...lines.map(
              (l) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(l, style: theme.textTheme.bodySmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OvernightCard extends StatelessWidget {
  const _OvernightCard();

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
            Text('Overnight Rate', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('Starting from', style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('\$250', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Chip(label: Text('7pm to 7am')),
            const SizedBox(height: 8),
            Text(
              'All bookings incur a \$69.00 non-refundable booking fee.\n'
              'Please note: A \$20 last minute charge applies to bookings made within 4 hours of the start time.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _OvernightNotes extends StatelessWidget {
  const _OvernightNotes();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _BulletPoint(
          'Our overnight pet sitting gives your pets comfort and care from 7:00pm to 7:00am.',
        ),
        _BulletPoint(
          'Your sitter will stay in your home so your pets can relax in their own familiar space.',
        ),
        _BulletPoint(
          'To ensure your sitter is comfortable, please provide a clean bed with sheets or a cosy couch to rest on.',
        ),
        _BulletPoint(
          'The overnight rate applies only when the sitter stays the full 7pm–7am period.',
        ),
        _BulletPoint(
          'Any hours outside this time frame are charged at the standard hourly rate.',
        ),
        _BulletPoint(
          'A booking fee applies to each overnight period and is payable before we begin securing your sitter.',
        ),
      ],
    );
  }
}

/// ---------------- WHY FAMILIES CHOOSE US ----------------

class _WhyFamiliesChooseUsSection extends StatelessWidget {
  const _WhyFamiliesChooseUsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFFF7F7F9),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We get the juggle – Because we’ve lived it',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFFFC94A),
            ),
          ),
          const SizedBox(height: 4),
          Text('Why families choose us', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
            'We know that every family is different, that every child and pet is an individual, '
            'with their own unique needs, routines and personalities – and we tailor our care to reflect that.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ExpansionTile(
            title: const Text('Happy Environment'),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pets feel their best when they’re in familiar surroundings. Our sitters come to your home, '
                  'creating a calm and happy environment where your pets are most comfortable.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('We Treat Your Pets Like Family'),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'We treat your pets with kindness, patience and genuine affection — just like our own.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Our promise we make to Families'),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'We’re committed to reliable, trustworthy care – with clear communication before, during and after each booking.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------------- AREAS WE COVER (WITH MAPS) ----------------

class _PetAreasWeCoverSection extends StatelessWidget {
  const _PetAreasWeCoverSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'More ways we care',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFFFC94A),
            ),
          ),
          const SizedBox(height: 4),
          Text('Areas we Cover?', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Our sitters proudly support families right across South East Qld. '
            'If your suburb isn’t listed, reach out — we’ll always do our best to accommodate and find a solution for your family.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Column(
            children: const [
              _AreaMapCard(
                title: 'Brisbane',
                description: 'Servicing from Caboolture to Beenleigh',
                imagePath: 'assets/icons/map_brisbane.png',
              ),
              SizedBox(height: 12),
              _AreaMapCard(
                title: 'Gold Coast',
                description: 'Servicing from Stapylton to Coolangatta',
                imagePath: 'assets/icons/map_goldcoast.png',
              ),
              SizedBox(height: 12),
              _AreaMapCard(
                title: 'Sunshine Coast',
                description: 'Servicing from Pelican Waters to Noosa Nth Shore',
                imagePath: 'assets/icons/map_sunshine.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AreaMapCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const _AreaMapCard({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static map image (you can replace with GoogleMap later)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset(
              imagePath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.titleMedium),
                const SizedBox(height: 4),
                Text(description, style: theme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------ SIMPLE BULLET WIDGET (REUSE FROM BEFORE) ------------

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
