import 'package:cloud_firestore/cloud_firestore.dart';

class SitterReview {
  final int rating;
  final String comment;
  final String userId;

  const SitterReview({
    required this.rating,
    required this.comment,
    required this.userId,
  });
}

class Sitter {
  final String id;
  final String name;
  final String bio;
  final String contactNumber;
  final String suburb;
  final List<String> careTypes;
  final List<String> services;
  final List<String> specialties;
  final List<AvailabilitySlot> availabilitySlots;
  final List<String> availability;
  final double ratePerHour;
  final double ratingAvg;
  final int ratingCount;
  final bool isAvailable;
  final String profileImageUrl;
  final List<String> galleryImageUrls;
  final GeoPoint location;
  final double distance;
  final List<SitterReview> reviews;

  const Sitter({
    required this.id,
    required this.name,
    required this.bio,
    required this.contactNumber,
    required this.suburb,
    required this.careTypes,
    required this.services,
    required this.specialties,
    required this.availabilitySlots,
    required this.availability,
    required this.ratePerHour,
    required this.ratingAvg,
    required this.ratingCount,
    required this.isAvailable,
    required this.profileImageUrl,
    required this.galleryImageUrls,
    required this.location,
    this.distance = 0,
    this.reviews = const [],
  });

  double get rating => ratingAvg;
  int get reviewsCount => ratingCount;
  String get img => profileImageUrl;
  String get suburbLabel => suburb.isNotEmpty ? suburb : '📍 Sydney CBD';
  String get statusLabel => ' ⭐ New';
  String get ratingText => ratingCount > 0
      ? '${ratingAvg.toStringAsFixed(1)} ($ratingCount reviews)'
      : 'New';
  String get distanceLabel => suburb.isNotEmpty ? ' $suburb' : 'Sydney CBD';
  String get ratingLabel {
    if (ratingCount > 0) {
      return '${ratingAvg.toStringAsFixed(1)} ($ratingCount reviews)  $statusLabel  $suburbLabel';
    }
    return '$statusLabel • $suburbLabel';
  }

  factory Sitter.fromFirestore(Map<String, dynamic> data) {
    final availabilitySlots = parseAvailabilitySlots(data['availabilitySlots']);
    final availabilityStrings = buildAvailabilityStrings(
      availabilitySlots,
      fallback: data['availability'],
    );
    final gallery = asStringList(data['galleryImageUrls'] ?? data['images']);
    final services = asStringList(data['services'] ?? data['servicesProvided']);
    final specialties = asStringList(
      data['specialties'] ?? data['specialities'],
    );
    final careTypes = resolveCareTypes(
      careTypes: data['careTypes'],
      type: data['type'],
      services: services,
      specialties: specialties,
    );
    final reviews = parseReviews(data['reviews']);

    return Sitter(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      bio: data['bio']?.toString() ?? '',
      contactNumber: data['contactNumber']?.toString() ?? '',
      suburb: data['suburb']?.toString() ?? '',
      careTypes: careTypes,
      services: services,
      specialties: specialties,
      availabilitySlots: availabilitySlots,
      availability: availabilityStrings,
      ratePerHour: toDoubleValue(data['ratePerHour'] ?? data['rate']),
      ratingAvg: toDoubleValue(data['ratingAvg'] ?? data['rating']),
      ratingCount: toIntValue(data['ratingCount'] ?? data['reviews']),
      isAvailable: data['isAvailable'] is bool ? data['isAvailable'] : true,
      profileImageUrl: resolveProfileImageUrl(data, gallery),
      galleryImageUrls: gallery,
      location: parseGeoPoint(data['location'], data['lat'], data['long']),
      distance: toDoubleValue(data['distance'] ?? 0),
      reviews: reviews,
    );
  }

  // Backwards compatible alias
  factory Sitter.fromMap(Map<String, dynamic> data) =>
      Sitter.fromFirestore(data);

  static List<String> asStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return [value.toString()];
  }

  static List<String> normalizeCareTypes(dynamic value) {
    final rawValues = asStringList(value).map((e) => e.toLowerCase()).toList();
    final normalized = <String>{};

    for (final item in rawValues) {
      if (item.contains('baby')) normalized.add('baby');
      if (item.contains('pet')) normalized.add('pet');
      if (item == 'both') {
        normalized.addAll(['baby', 'pet']);
      }
    }

    return normalized.toList();
  }

  static List<String> resolveCareTypes({
    dynamic careTypes,
    dynamic type,
    List<String> services = const [],
    List<String> specialties = const [],
  }) {
    final normalized = normalizeCareTypes(careTypes ?? type);
    if (normalized.isNotEmpty) return normalized;

    final lowerServices = services.map((e) => e.toLowerCase()).toList();
    final lowerSpecialties = specialties.map((e) => e.toLowerCase()).toList();
    final inferred = <String>{};

    bool containsKeyword(List<String> list, List<String> keywords) =>
        list.any((item) => keywords.any((keyword) => item.contains(keyword)));

    if (containsKeyword(lowerServices, [
          'pet',
          'dog',
          'cat',
          'animal',
          'vet',
        ]) ||
        containsKeyword(lowerSpecialties, [
          'pet',
          'dog',
          'cat',
          'animal',
          'vet',
        ])) {
      inferred.add('pet');
    }

    if (containsKeyword(lowerServices, [
          'baby',
          'infant',
          'child',
          'kid',
          'newborn',
          'school',
        ]) ||
        containsKeyword(lowerSpecialties, [
          'baby',
          'infant',
          'child',
          'kid',
          'newborn',
          'school',
        ])) {
      inferred.add('baby');
    }

    return inferred.toList();
  }

  static double toDoubleValue(dynamic value) {
    if (value is num) {
      if (value.isNaN || value.isInfinite) return 0;
      return value.toDouble();
    }
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int toIntValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static GeoPoint parseGeoPoint(dynamic location, dynamic lat, dynamic long) {
    if (location is GeoPoint) return location;
    final mapLocation = location as Map<String, dynamic>?;
    if (mapLocation != null &&
        mapLocation['latitude'] != null &&
        mapLocation['longitude'] != null) {
      return GeoPoint(
        toDoubleValue(mapLocation['latitude']),
        toDoubleValue(mapLocation['longitude']),
      );
    }

    final latitude = toDoubleValue(lat);
    final longitude = toDoubleValue(long);

    if (latitude != 0 || longitude != 0) {
      return GeoPoint(latitude, longitude);
    }

    // Default to Sydney CBD if missing
    return const GeoPoint(-33.8688, 151.2093);
  }

  static List<AvailabilitySlot> parseAvailabilitySlots(dynamic value) {
    if (value is! List) return [];

    return value
        .map((e) => AvailabilitySlot.fromMap(e as Map<String, dynamic>? ?? {}))
        .toList();
  }

  static List<String> buildAvailabilityStrings(
    List<AvailabilitySlot> slots, {
    dynamic fallback,
  }) {
    if (slots.isEmpty) return asStringList(fallback);

    return slots
        .map(
          (slot) => slot.slots.isNotEmpty
              ? "${slot.date}: ${slot.slots.join(", ")}"
              : slot.date,
        )
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static List<SitterReview> parseReviews(dynamic value) {
    if (value is! List) return [];

    return value.map((item) {
      final map = item as Map<String, dynamic>? ?? {};
      // Handle both 'userId' (old) and 'reviewerName' (seeder)
      final reviewer =
          map['reviewerName']?.toString() ??
          map['userId']?.toString() ??
          'User';
      return SitterReview(
        rating: toIntValue(map['rating']),
        comment: map['comment']?.toString() ?? '',
        userId: reviewer,
      );
    }).toList();
  }

  static String resolveProfileImageUrl(
    Map<String, dynamic> data,
    List<String> gallery,
  ) {
    final rawUrl =
        (data['profileImageUrl'] ??
                data['profileImage'] ??
                (gallery.isNotEmpty ? gallery.first : ''))
            .toString()
            .trim();

    if (rawUrl.isNotEmpty) return rawUrl;
    // Fallback placeholder prevents navigation crashes when no image is provided.
    return 'https://placehold.co/200x200?text=Sitter';
  }

  Map<String, dynamic> toMap() {
    final nameParts = name.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'contactNumber': contactNumber,
      'phoneNumber': contactNumber, // Alias for SitterEditProfile
      'suburb': suburb,
      'careTypes': careTypes,
      'services': services,
      'specialties': specialties,
      'availabilitySlots': availabilitySlots.map((e) => e.toMap()).toList(),
      'ratePerHour': ratePerHour,
      'ratingAvg': ratingAvg,
      'ratingCount': ratingCount,
      'isAvailable': isAvailable,
      'profileImageUrl': profileImageUrl,
      'galleryImageUrls': galleryImageUrls,
      'location': location,
      'distance': distance,
    };
  }
}

class AvailabilitySlot {
  final String date;
  final List<String> slots;

  const AvailabilitySlot({required this.date, required this.slots});

  factory AvailabilitySlot.fromMap(Map<String, dynamic> data) {
    return AvailabilitySlot(
      date: data['date']?.toString() ?? '',
      slots: Sitter.asStringList(data['slots']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'slots': slots};
  }
}
