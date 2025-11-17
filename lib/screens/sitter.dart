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
