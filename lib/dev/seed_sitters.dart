import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Seed realistic sitter documents with sub-collections for reviews.
Future<void> seedSitters({bool overwrite = false}) async {
  final firestore = FirebaseFirestore.instance;

  // WIPE existing data if overwrite is requested
  if (overwrite) {
    if (kDebugMode) debugPrint('Wiping existing sitters collection...');
    final snapshot = await firestore.collection('sitters').get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  final seeds = _buildRealisticSeeds();

  for (final seed in seeds) {
    // Sitter ID based on name for stability (e.g. sitter_alice)
    final docId =
        'sitter_${seed['name'].toString().split(' ').first.toLowerCase()}';
    final docRef = firestore.collection('sitters').doc(docId);

    final existing = await docRef.get();
    if (existing.exists && !overwrite) {
      if (kDebugMode) debugPrint('Skipping $docId (exists)');
      continue;
    }

    // Keep reviews in the main document for the UI list,
    // AND seed them as a subcollection for scalable querying later.
    final reviews = seed['reviews'] as List<Map<String, dynamic>>?;

    final payload = {
      ...seed,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(payload);

    // Seed Reviews in Subcollection
    if (reviews != null) {
      final reviewsRef = docRef.collection('reviews');
      // Clear existing reviews if overwriting
      if (overwrite) {
        final existingReviews = await reviewsRef.get();
        for (final doc in existingReviews.docs) {
          await doc.reference.delete();
        }
      }
      for (final review in reviews) {
        await reviewsRef.add({
          ...review,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    if (kDebugMode)
      debugPrint('Seeded $docId with ${reviews?.length ?? 0} reviews');
  }
}

/// Delete sitters named "Sitter X" (legacy garbage data)
Future<void> cleanupLegacySitters() async {
  final firestore = FirebaseFirestore.instance;
  try {
    final snapshot = await firestore.collection('sitters').get();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final name = data['name'] as String?;
      if (name != null && name.startsWith('Sitter ')) {
        if (kDebugMode) debugPrint('Deleting legacy sitter: $name (${doc.id})');
        await doc.reference.delete();
      }
    }
  } catch (e) {
    debugPrint('Error cleaning up legacy sitters: $e');
  }
}

List<Map<String, dynamic>> _buildRealisticSeeds() {
  final now = DateTime.now();

  // Helper to generate next 2 weeks of availability
  List<Map<String, dynamic>> generateSlots() {
    return List.generate(5, (i) {
      final date = now.add(Duration(days: i + 1));
      return {
        'date':
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'slots': [
          'Morning',
          'Afternoon',
          'Evening',
        ].sublist(0, 1 + Random().nextInt(3)),
      };
    });
  }

  return [
    {
      'name': 'John walker',
      'bio':
          'Loves caring for puppies and kittens. I have 1 year of professional experience and grew up on a farm.',
      'contactNumber': '0477 888 555',
      'suburb': 'Sydney CBD',
      'careTypes': ['pet'],
      'services': ['Dog Walking', 'Pet Sitting'],
      'specialties': ['Puppies', 'Kittens', 'Farm Animals'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 19.0,
      'ratingAvg': 4.0,
      'ratingCount': 12,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.8688, 151.2093),
      'reviews': [
        {
          'reviewerName': 'John Trud.',
          'rating': 5,
          'comment': 'John was amazing with our new puppy!',
        },
        {
          'reviewerName': 'Sarah M.',
          'rating': 4,
          'comment': 'Very reliable and sweet.',
        },
        {
          'reviewerName': 'Kevin L.',
          'rating': 4,
          'comment': 'Great with our kitten, very attentive.',
        },
        {
          'reviewerName': 'Hannah G.',
          'rating': 5,
          'comment': 'John obviously knows his stuff with farm animals.',
        },
        {
          'reviewerName': 'Paul T.',
          'rating': 5,
          'comment': 'A natural with pets. Highly recommend.',
        },
        {
          'reviewerName': 'Lisa D.',
          'rating': 4,
          'comment': 'Good service and very friendly.',
        },
        {
          'reviewerName': 'Mark J.',
          'rating': 5,
          'comment': 'Professional and punctual.',
        },
      ],
    },
    {
      'name': 'Benjamin King',
      'bio':
          'Experienced sitter for both babies and pets. I am patient, reliable, and fun!',
      'contactNumber': '0412 111 222',
      'suburb': 'Sydney CBD',
      'careTypes': ['baby', 'pet'],
      'services': ['Babysitting', 'Pet Care', 'House Sitting'],
      'specialties': ['Toddlers', 'Active Dogs'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 40.0,
      'ratingAvg': 4.8,
      'ratingCount': 35,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1587502537745-84b86da1204f?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.8700, 151.2100),
      'reviews': [
        {
          'reviewerName': 'Emily R.',
          'rating': 5,
          'comment':
              'Benjamin is simply the best. My kids ask for him by name.',
        },
        {
          'reviewerName': 'Chris M.',
          'rating': 5,
          'comment': 'Fantastic with our toddler and our energetic lab.',
        },
        {
          'reviewerName': 'Jessica B.',
          'rating': 5,
          'comment': 'Very trustworthy and reliable.',
        },
        {
          'reviewerName': 'Dave K.',
          'rating': 4,
          'comment': 'Great guy, very patient and kind.',
        },
        {
          'reviewerName': 'Sophie L.',
          'rating': 5,
          'comment': 'Benjamin is a lifesaver for our busy family.',
        },
        {
          'reviewerName': 'Nick P.',
          'rating': 5,
          'comment': 'Highly recommend for anyone with kids and pets.',
        },
        {
          'reviewerName': 'Olivia W.',
          'rating': 5,
          'comment': 'The best sitter we have ever had.',
        },
      ],
    },
    {
      'name': 'Emma Johnson',
      'bio':
          'Passionate about animal welfare. I specialize in dogs and cats and can administer medication if needed.',
      'contactNumber': '0422 333 444',
      'suburb': 'Sydney CBD',
      'careTypes': ['pet'],
      'services': ['Dog Walking', 'Cat Sitting'],
      'specialties': ['Senior Pets', 'Medication'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 25.0,
      'ratingAvg': 4.5,
      'ratingCount': 28,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.8750, 151.2050),
      'reviews': [
        {
          'reviewerName': 'Chris P.',
          'rating': 4,
          'comment': 'Emma took great care of our aging cat.',
        },
        {
          'reviewerName': 'Olivia W.',
          'rating': 5,
          'comment': 'Reliable and communicative. Highly recommend.',
        },
        {
          'reviewerName': 'Nathan D.',
          'rating': 5,
          'comment': 'Best pet sitter we have had in years.',
        },
        {
          'reviewerName': 'Sophie Q.',
          'rating': 4,
          'comment': 'Very kind and patient with our nervous dog.',
        },
        {
          'reviewerName': 'Jack R.',
          'rating': 5,
          'comment': 'Emma is a true professional.',
        },
        {
          'reviewerName': 'Lily M.',
          'rating': 5,
          'comment': 'Highly recommend Emma for any pet care needs.',
        },
        {
          'reviewerName': 'Noah S.',
          'rating': 4,
          'comment': 'Great service, our dog was very happy.',
        },
      ],
    },
    {
      'name': 'Mia Taylor',
      'bio':
          'University student who loves kids and dogs. I bring energy and creativity to every job.',
      'contactNumber': '0433 444 555',
      'suburb': 'Sydney CBD',
      'careTypes': ['baby', 'pet'],
      'services': ['Babysitting', 'Dog Walking'],
      'specialties': ['Arts & Crafts', 'Puppies'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 24.0,
      'ratingAvg': 4.7,
      'ratingCount': 15,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1602526430780-782d6b1783fa?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.8800, 151.2000),
      'reviews': [
        {
          'reviewerName': 'Jessica L.',
          'rating': 5,
          'comment': 'Mia is full of energy! The kids and dog were exhausted.',
        },
        {
          'reviewerName': 'Andrew G.',
          'rating': 5,
          'comment': 'The arts and crafts activities were a hit!',
        },
        {
          'reviewerName': 'Rachel O.',
          'rating': 4,
          'comment': 'Very sweet and responsible.',
        },
        {
          'reviewerName': 'Mark V.',
          'rating': 5,
          'comment': 'Mia is great with our puppy.',
        },
        {
          'reviewerName': 'Lauren S.',
          'rating': 5,
          'comment': 'Highly energetic and very creative.',
        },
        {
          'reviewerName': 'Tom R.',
          'rating': 4,
          'comment': 'Happy with everything, Mia is great.',
        },
        {
          'reviewerName': 'Kate B.',
          'rating': 5,
          'comment': 'The best university sitter we have found.',
        },
      ],
    },
    {
      'name': 'Ethan Davis',
      'bio':
          'Reliable sitter fitting work around my studies. Detail oriented and trustworthy.',
      'contactNumber': '0444 555 666',
      'suburb': 'Sydney CBD',
      'careTypes': ['pet'],
      'services': ['House Sitting', 'Pet Feeding'],
      'specialties': ['Small Dogs', 'Exotic Pets'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 21.0,
      'ratingAvg': 4.6,
      'ratingCount': 10,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1542343633-ce3256f2183e?auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [],
      'location': const GeoPoint(-33.8820, 151.2150),
      'reviews': [
        {
          'reviewerName': 'Karen B.',
          'rating': 5,
          'comment': 'Ethan followed our complex instructions perfectly.',
        },
        {
          'reviewerName': 'Mark S.',
          'rating': 5,
          'comment': 'Quiet, respectful, and great with our fish!',
        },
        {
          'reviewerName': 'Linda T.',
          'rating': 4,
          'comment': 'On time and very polite.',
        },
        {
          'reviewerName': 'Steve H.',
          'rating': 5,
          'comment': 'Very reliable house sitter.',
        },
        {
          'reviewerName': 'Mary J.',
          'rating': 5,
          'comment': 'Ethan is very trustworthy.',
        },
        {
          'reviewerName': 'Bob D.',
          'rating': 4,
          'comment': 'Good communication throughout the stay.',
        },
        {
          'reviewerName': 'Alice P.',
          'rating': 5,
          'comment': 'Would definitely hire Ethan again.',
        },
      ],
    },
    {
      'name': 'Liam Anderson',
      'bio':
          'Friendly and experienced with all kinds of pets. Available on short notice.',
      'contactNumber': '0455 666 777',
      'suburb': 'Sydney CBD',
      'careTypes': ['pet'],
      'services': ['Pet Sitting', 'Quick Visits'],
      'specialties': ['Birds', 'Fish', 'Cats'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 20.0,
      'ratingAvg': 4.3,
      'ratingCount': 8,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [],
      'location': const GeoPoint(-33.8850, 151.2200),
      'reviews': [
        {
          'reviewerName': 'Tom S.',
          'rating': 4,
          'comment': 'Liam helped us out in a pinch. Very grateful.',
        },
        {
          'reviewerName': 'Anna K.',
          'rating': 5,
          'comment': 'Great with our rescue cat.',
        },
        {
          'reviewerName': 'Peter W.',
          'rating': 4,
          'comment': 'Friendly guy and very reliable.',
        },
        {
          'reviewerName': 'Julia R.',
          'rating': 5,
          'comment': 'Liam is wonderful with animals.',
        },
        {
          'reviewerName': 'Sam B.',
          'rating': 4,
          'comment': 'Happy with the service provided.',
        },
        {
          'reviewerName': 'Lucy G.',
          'rating': 5,
          'comment': 'Highly recommend Liam for pet visits.',
        },
        {
          'reviewerName': 'Dan H.',
          'rating': 4,
          'comment': 'Very easy to deal with, great service.',
        },
      ],
    },
    {
      'name': 'Emily Thompson',
      'bio':
          'Certified pediatric nurse with over 10 years of childcare experience. I specialize in newborn care.',
      'contactNumber': '0412 345 678',
      'suburb': 'Bondi Beach',
      'careTypes': ['baby'],
      'services': ['Newborn Care', 'Night Nanny', 'Sleep Training'],
      'specialties': ['Certified Nurse', 'First Aid', 'Non-smoker'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 35.0,
      'ratingAvg': 5.0,
      'ratingCount': 24,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1519689680058-324335c77eba?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.8915, 151.2767),
      'reviews': [
        {
          'reviewerName': 'Sarah J.',
          'rating': 5,
          'comment': 'Emily was a lifesaver with our newborn!',
        },
        {
          'reviewerName': 'Mike T.',
          'rating': 5,
          'comment': 'Professional, punctual, and amazing with kids.',
        },
        {
          'reviewerName': 'Rachel V.',
          'rating': 5,
          'comment': 'Incredible knowledge and very supportive.',
        },
        {
          'reviewerName': 'David N.',
          'rating': 5,
          'comment': 'Best night nanny we have had.',
        },
        {
          'reviewerName': 'Emma S.',
          'rating': 5,
          'comment': 'Highly skilled and very gentle.',
        },
        {
          'reviewerName': 'Josh W.',
          'rating': 5,
          'comment': 'Extremely professional and caring.',
        },
        {
          'reviewerName': 'Laura C.',
          'rating': 5,
          'comment': 'A true expert in newborn care.',
        },
      ],
    },
    {
      'name': 'James Wilson',
      'bio':
          'Active and energetic pet sitter. I love dogs of all sizes and exercise is my priority.',
      'contactNumber': '0423 456 789',
      'suburb': 'Surry Hills',
      'careTypes': ['pet'],
      'services': ['Dog Walking', 'Pet Sitting', 'House Sitting'],
      'specialties': ['Large Dogs', 'Active Play', 'Medication Admin'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 28.0,
      'ratingAvg': 4.9,
      'ratingCount': 42,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1542206395-9feb3edaa75d?auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.8861, 151.2111),
      'reviews': [
        {
          'reviewerName': 'Jenny L.',
          'rating': 5,
          'comment': 'My golden retriever absolutely loves James!',
        },
        {
          'reviewerName': 'Tom H.',
          'rating': 4,
          'comment': 'Great communication and daily updates.',
        },
        {
          'reviewerName': 'Alice G.',
          'rating': 5,
          'comment': 'James is fantastic with energetic pups.',
        },
        {
          'reviewerName': 'Robert F.',
          'rating': 5,
          'comment': 'Very reliable and trustworthy walker.',
        },
        {
          'reviewerName': 'Catherine P.',
          'rating': 5,
          'comment': 'Our dog is always so excited to see him.',
        },
        {
          'reviewerName': 'Michael B.',
          'rating': 5,
          'comment': 'Highly professional and great with animals.',
        },
        {
          'reviewerName': 'Zoe K.',
          'rating': 5,
          'comment': 'Great value and top tier service.',
        },
      ],
    },
    {
      'name': 'Sophia Chen',
      'bio':
          'University student studying Early Childhood Education. I love arts & crafts.',
      'contactNumber': '0434 567 890',
      'suburb': 'Chatswood',
      'careTypes': ['baby'],
      'services': ['Babysitting', 'Homework Help', 'Arts & Crafts'],
      'specialties': ['Toddlers', 'Creative Play', 'Tutor'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 25.0,
      'ratingAvg': 4.7,
      'ratingCount': 15,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.7961, 151.1831),
      'reviews': [
        {
          'reviewerName': 'Alice M.',
          'rating': 5,
          'comment': 'Sophia is wonderful with my 4yo daughter.',
        },
        {
          'reviewerName': 'Ben T.',
          'rating': 5,
          'comment': 'Great help with homework and very patient.',
        },
        {
          'reviewerName': 'Chloe W.',
          'rating': 4,
          'comment': 'Very creative activities for toddlers.',
        },
        {
          'reviewerName': 'James K.',
          'rating': 5,
          'comment': 'Sophia is professional and kind.',
        },
        {
          'reviewerName': 'Lily P.',
          'rating': 5,
          'comment': 'Highly recommend for educational babysitting.',
        },
        {
          'reviewerName': 'Noah F.',
          'rating': 4,
          'comment': 'Gentle and very supportive with learning.',
        },
        {
          'reviewerName': 'Grace V.',
          'rating': 5,
          'comment': 'Wonderful sitter, very reliable.',
        },
      ],
    },
    {
      'name': 'Lucas Brown',
      'bio':
          'Experienced with both kids and pets! I am your go-to person for busy households.',
      'contactNumber': '0445 678 901',
      'suburb': 'Newtown',
      'careTypes': ['baby', 'pet'],
      'services': ['Babysitting', 'Pet Sitting', 'Overnight'],
      'specialties': ['Multi-tasking', 'Cooking', 'Driver License'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 30.0,
      'ratingAvg': 4.8,
      'ratingCount': 33,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80',
      'galleryImageUrls': [
        'https://images.unsplash.com/photo-1587502537745-84b86da1204f?auto=format&fit=crop&w=800&q=80',
      ],
      'location': const GeoPoint(-33.8975, 151.1796),
      'reviews': [
        {
          'reviewerName': 'Paul R.',
          'rating': 5,
          'comment': 'Lucas managed our 3 kids and 2 dogs perfectly.',
        },
        {
          'reviewerName': 'Emma G.',
          'rating': 5,
          'comment': 'Incredible multitasking skills and a great cook!',
        },
        {
          'reviewerName': 'Tom B.',
          'rating': 5,
          'comment': 'Very reliable and trustworthy.',
        },
        {
          'reviewerName': 'Sarah K.',
          'rating': 4,
          'comment': 'Lucas is very competent and calm.',
        },
        {
          'reviewerName': 'Jack H.',
          'rating': 5,
          'comment': 'He stayed overnight and everything was perfect.',
        },
        {
          'reviewerName': 'Mia J.',
          'rating': 5,
          'comment': 'Highly recommended for complex households.',
        },
        {
          'reviewerName': 'Ryan D.',
          'rating': 5,
          'comment': 'A true pro, handled everything with ease.',
        },
      ],
    },
    {
      'name': 'Olivia Martinez',
      'bio':
          'Professional nanny with focus on educational development. Bilingual (Spanish/English).',
      'contactNumber': '0456 789 012',
      'suburb': 'Manly',
      'careTypes': ['baby'],
      'services': ['Nanny', 'Language Tutoring', 'Meal Prep'],
      'specialties': ['Bilingual', 'Education', 'Nutrition'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 40.0,
      'ratingAvg': 5.0,
      'ratingCount': 56,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=633&q=80',
      'galleryImageUrls': [],
      'location': const GeoPoint(-33.8001, 151.2870),
      'reviews': [
        {
          'reviewerName': 'Maria G.',
          'rating': 5,
          'comment': 'Olivia is part of the family now. We love her.',
        },
        {
          'reviewerName': 'Carlos R.',
          'rating': 5,
          'comment': 'Excellent language tutoring for our kids.',
        },
        {
          'reviewerName': 'Elena S.',
          'rating': 5,
          'comment': 'Professional, dedicated, and very caring.',
        },
        {
          'reviewerName': 'Mateo B.',
          'rating': 5,
          'comment': 'Her educational focus is exactly what we needed.',
        },
        {
          'reviewerName': 'Sofia L.',
          'rating': 5,
          'comment': 'Bilingual support has been invaluable.',
        },
        {
          'reviewerName': 'Lucas M.',
          'rating': 5,
          'comment': 'The meal prep is healthy and delicious.',
        },
        {
          'reviewerName': 'Isabel T.',
          'rating': 5,
          'comment': 'Incredible nanny, highly recommended.',
        },
      ],
    },
    {
      'name': 'Evan Lee',
      'bio':
          'Dog trainer in training! I can help with basic commands and leash training.',
      'contactNumber': '0467 890 123',
      'suburb': 'Parramatta',
      'careTypes': ['pet'],
      'services': ['Dog Walker', 'Training', 'Day Care'],
      'specialties': ['Training', 'High Energy Dogs', 'Day Trips'],
      'availabilitySlots': generateSlots(),
      'ratePerHour': 32.0,
      'ratingAvg': 4.6,
      'ratingCount': 19,
      'isAvailable': true,
      'profileImageUrl':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
      'galleryImageUrls': [],
      'location': const GeoPoint(-33.8150, 151.0011),
      'reviews': [
        {
          'reviewerName': 'David K.',
          'rating': 4,
          'comment': 'Evan has great control over the dogs.',
        },
        {
          'reviewerName': 'Lisa T.',
          'rating': 5,
          'comment': 'Our dog has improved so much with Evan.',
        },
        {
          'reviewerName': 'Mark N.',
          'rating': 5,
          'comment': 'Very knowledgeable about dog behavior.',
        },
        {
          'reviewerName': 'Sophie W.',
          'rating': 4,
          'comment': 'Great energy and very patient.',
        },
        {
          'reviewerName': 'Adam B.',
          'rating': 5,
          'comment': 'Highly recommend for high energy dogs.',
        },
        {
          'reviewerName': 'Lucy C.',
          'rating': 5,
          'comment': 'Evan is a fantastic trainer.',
        },
        {
          'reviewerName': 'Chris R.',
          'rating': 5,
          'comment': 'Best walker in the Parramatta area.',
        },
      ],
    },
  ];
}
