import 'package:flutter/material.dart';
import '../screens/families_screen.dart';
import '../screens/sitters_screen.dart';
import 'babysitting_screen.dart';
import 'book_babysitter_screen.dart';
import 'book_petsitter_screen.dart';
import 'pet_sitting_screen.dart';

// later you can create dedicated screens for pet sitting and contact
// and update the navigation calls.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // top bar: logo + phone number like the site
        titleSpacing: 0,
        title: Row(
          children: [
            // app / company logo
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                'assets/icons/logo.png', // <- put your logo here
                height: 32,
              ),
            ),
            const SizedBox(width: 8),
            const Text('City to Coast Sitting'),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                '1800 282 277',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _HeroSection(),
              _AboutSection(),
              _BabysittingSection(),
              _PetSittingSection(),
              _ExtendedServicesSection(),
              _WhyFamiliesChooseUsSection(),
              _JoinOurTeamSection(),
              _FooterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------- HERO SECTION (big image + 3 buttons) -----------------

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.45,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background hero image
          // Replace with correct path to your family/pet hero image
          Image.asset(
            'assets/icons/hero_family.jpg', // TODO: add your image
            fit: BoxFit.cover,
          ),
          // subtle overlay for text readability
          Container(color: Colors.black.withOpacity(0.25)),
          // Center text + CTA buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Baby & Pet Sitters',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      height: 1.3,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'On-the-Go Families\nMeet On-Demand Care',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 17,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _HeroButton(
                        label: 'Book a Babysitter',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const BabysittingScreen(),
                            ),
                          );
                        },
                      ),
                      _HeroButton(
                        label: 'Book a Pet sitter',
                        onTap: () {
                          // for now you can also send this to FamiliesScreen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PetSittingScreen(),
                            ),
                          );
                        },
                      ),
                      _HeroButton(
                        label: 'Join our Team',
                        isSecondary: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SittersScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;

  const _HeroButton({
    required this.label,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final ButtonStyle style = isSecondary
        ? OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.9)),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          );

    return SizedBox(
      height: 40,
      child: isSecondary
          ? OutlinedButton(onPressed: onTap, style: style, child: Text(label))
          : ElevatedButton(onPressed: onTap, style: style, child: Text(label)),
    );
  }
}

/// -------------- ABOUT SECTION -----------------

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Care for Your Children and Pets',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            // shorten & generalise text — you can replace this with exact wording
            'City to Coast Sitting provides reliable babysitting and pet sitting services '
            'across Brisbane, the Gold Coast and the Sunshine Coast. We tailor in-home '
            'and holiday care to fit your family’s routine so that your kids and fur-babies '
            'are happy, safe and supported.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// -------------- BABYSITTING SECTION -----------------

class _BabysittingSection extends StatelessWidget {
  const _BabysittingSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Babysitting Made Simple',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3384D9), // similar blue to website
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Life doesn’t always run to schedule. Our babysitting service is designed '
            'to be flexible, reliable and stress-free – from newborns to busy primary '
            'schoolers and even teens.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _ChipTag('Special events'),
              _ChipTag('Weddings'),
              _ChipTag('Night off'),
              _ChipTag('Extra work shifts'),
            ],
          ),
        ],
      ),
    );
  }
}

/// -------------- PET SITTING SECTION -----------------

class _PetSittingSection extends StatelessWidget {
  const _PetSittingSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trusted Pet Sitting – day or night',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3384D9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Whether it’s daytime visits, evening check-ins or overnight stays, we '
            'know pets feel happiest with familiar faces and routine. Our sitters are '
            'animal lovers who treat your pets like family.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// -------------- EXTENDED SERVICES SECTION -----------------

class _ExtendedServicesSection extends StatelessWidget {
  const _ExtendedServicesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Extended Sitting Services',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3384D9),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: const [
              _ServiceCard(
                title: 'Holiday Care',
                description:
                    'Heading away or planning a well-deserved break? Our sitters keep '
                    'your children and pets safe, happy and in capable hands while you travel.',
              ),
              SizedBox(height: 12),
              _ServiceCard(
                title: 'Overnight Care',
                description:
                    'Need support for night shifts, late events or multi-day trips? '
                    'Our overnight sitters provide calm, consistent care so you can rest easy.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;

  const _ServiceCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // later: navigate to Contact / enquiry screen
              },
              child: const Text('Contact Us'),
            ),
          ],
        ),
      ),
    );
  }
}

/// -------------- WHY FAMILIES CHOOSE US SECTION -----------------

class _WhyFamiliesChooseUsSection extends StatelessWidget {
  const _WhyFamiliesChooseUsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why families choose us',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3384D9),
            ),
          ),
          const SizedBox(height: 12),
          const _BulletPoint(
            'Our employees care – we carefully select sitters who genuinely '
            'enjoy working with children and animals.',
          ),
          const _BulletPoint(
            'Happy environment – we focus on creating calm, fun and safe experiences.',
          ),
          const _BulletPoint(
            'We treat your pets like family – we respect your routines and preferences.',
          ),
        ],
      ),
    );
  }
}

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

/// -------------- JOIN OUR TEAM SECTION -----------------

class _JoinOurTeamSection extends StatelessWidget {
  const _JoinOurTeamSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Join our Team at\nCity to Coast Sitting',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF3384D9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We’re always looking for caring, dependable people who love children '
            'and pets. Choose flexible hours, make a difference for families and '
            'be supported by a friendly local team.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SittersScreen()));
            },
            child: const Text('Become a sitter'),
          ),
        ],
      ),
    );
  }
}

/// -------------- FOOTER SECTION -----------------

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF003552), // deep blue similar to footer image
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        children: [
          // Logo + short text
          Row(
            children: [
              Image.asset('assets/icons/logo.png', height: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Our professional Baby and Pet Sitters are committed to '
                  'fostering a safe, enriching environment where children and '
                  'pets are cared for with empathy and attention.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Useful links & contact
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FooterHeading('Locations'),
                    Text('Gold Coast', style: TextStyle(color: Colors.white70)),
                    Text(
                      'Sunshine Coast',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text('Brisbane', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FooterHeading('Contact us'),
                    Text(
                      'info@citytocoastsitting.com.au',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '1800 282 277',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '© City to Coast Baby & Pet Sitting',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FooterHeading extends StatelessWidget {
  final String text;

  const _FooterHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// -------------- SMALL REUSABLE WIDGETS -----------------

class _ChipTag extends StatelessWidget {
  final String label;

  const _ChipTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.yellow.shade100,
      labelStyle: const TextStyle(fontSize: 12),
    );
  }
}
