class Sitter {
  final String name;
  final double rating;
  final int reviews;
  final double ratePerHour;
  final String bio;
  final List<String> specialties;
  final List<String> availability;
  final double distance;
  final List<String> tags;
  final String img;

  Sitter({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.ratePerHour,
    required this.bio,
    required this.specialties,
    required this.availability,
    required this.distance,
    required this.tags,
    required this.img,
  });

  // Factory method to build from Map<String, dynamic>
  factory Sitter.fromMap(Map<String, dynamic> data) {
    return Sitter(
      name: data['name'],
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: data['reviews'] ?? 0,
      ratePerHour: (data['rate'] ?? 0).toDouble(),
      bio: data['bio'] ?? '',
      specialties: List<String>.from(data['specialties'] ?? []),
      availability: List<String>.from(data['availability'] ?? []),
      distance: (data['distance'] ?? 0).toDouble(),
      tags: List<String>.from(data['tags'] ?? []),
      img: data['img'] ?? '',
    );
  }
}

class SitterApiModel {
  final String id;
  final String name;
  final String bio;
  final String experience;
  final String contactNumber;
  final double ratePerHour;
  final double milesAway;
  final int distance;
  final int lat;
  final int long;
  final int rating;
  final bool availability;
  final List<String> servicesProvided;
  final List<String> specialties;
  final List<AvailabilitySlot> availabilitySlots;
  final List<String> images;
  final String profileImage;
  final List<ReviewModel> reviews;

  SitterApiModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.experience,
    required this.contactNumber,
    required this.ratePerHour,
    required this.milesAway,
    required this.distance,
    required this.lat,
    required this.long,
    required this.rating,
    required this.availability,
    required this.servicesProvided,
    required this.specialties,
    required this.availabilitySlots,
    required this.images,
    required this.profileImage,
    required this.reviews,
  });

  // 🔹 Factory from Map
  factory SitterApiModel.fromMap(Map<String, dynamic> data) {
    return SitterApiModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      experience: data['experience'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      ratePerHour: double.parse(data['ratePerHour'].toString()),
      milesAway: double.parse(data['milesAway'].toString()),
      distance: data['distance'] ?? 0,
      lat: data['lat'] ?? 0,
      long: data['long'] ?? 0,
      rating: data['rating'] ?? 0,
      availability: data['availability'] ?? true,
      servicesProvided: List<String>.from(data['servicesProvided'] ?? []),
      specialties: List<String>.from(data['specialties'] ?? []),
      availabilitySlots: (data['availabilitySlots'] as List<dynamic>? ?? [])
          .map((e) => AvailabilitySlot.fromMap(e))
          .toList(),
      images: List<String>.from(data['images'] ?? []),
      profileImage: data['profileImage'] ?? '',
      reviews: (data['reviews'] as List<dynamic>? ?? [])
          .map((e) => ReviewModel.fromMap(e))
          .toList(),
    );
  }

  get tags => null;
}

// ✅ Availability model
class AvailabilitySlot {
  final String date;
  final List<String> slots;

  AvailabilitySlot({required this.date, required this.slots});

  factory AvailabilitySlot.fromMap(Map<String, dynamic> data) {
    return AvailabilitySlot(
      date: data['date'] ?? '',
      slots: List<String>.from(data['slots'] ?? []),
    );
  }
}

// ✅ Review model
class ReviewModel {
  final int rating;
  final String comment;
  final String userId;

  ReviewModel({
    required this.rating,
    required this.comment,
    required this.userId,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}
