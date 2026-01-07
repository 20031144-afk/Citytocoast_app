import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sitter.dart';

class EmergencyBookingScreen extends StatelessWidget {
  const EmergencyBookingScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> emergencySitters = const [
    {
      "name": "Emma Johnson",
      "rating": 4.9,
      "reviews": 156,
      "distance": 0.3,
      "rate": 35,
      "eta": "8 mins",
      "tags": ["Newborn Specialist", "Emergency Care"],
      "available": true,
      "profileImageUrl":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=634&q=80",
    },
    {
      "name": "James Wilson",
      "rating": 4.8,
      "reviews": 203,
      "distance": 0.5,
      "rate": 42,
      "eta": "12 mins",
      "tags": ["Emergency Pet Care", "Vet Assistant"],
      "available": true,
      "profileImageUrl":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=634&q=80",
    },
    {
      "name": "Liam Anderson",
      "rating": 4.7,
      "reviews": 89,
      "distance": 0.7,
      "rate": 38,
      "eta": "Unavailable",
      "tags": ["Special Needs", "Rapid Response"],
      "available": false,
      "profileImageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=634&q=80",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Priority Booking",
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF4B2B), Color(0xFFFF416C)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF4B2B), Color(0xFFFF416C)],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 120, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Need Help Now?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Get priority response from our top-rated emergency-certified sitters.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInfoBanner(),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Available Near You",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "View Map",
                          style: TextStyle(
                            color: Color(0xFFFF416C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...emergencySitters.map(
                    (sitter) => _buildSitterCard(context, sitter),
                  ),
                  const SizedBox(height: 32),
                  _buildFeaturesSection(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF416C).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flash_on,
              color: Color(0xFFFF416C),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Priority Response Guaranteed",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  "Sitters respond in as little as 5 minutes.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSitterCard(BuildContext context, Map<String, dynamic> sitter) {
    final bool isAvailable = sitter["available"];
    return GestureDetector(
      onTap: isAvailable
          ? () {
              // Creating a Sitter object from the map for the details screen
              final s = Sitter(
                id: sitter["name"].toLowerCase().split(" ").first,
                name: sitter["name"],
                bio: "Emergency certified caregiver with specialized training.",
                contactNumber: "0400 000 000",
                suburb: "Nearby",
                careTypes: sitter["tags"],
                services: ["Emergency Care", "Immediate Support"],
                specialties: ["First Aid", "Rapid Response"],
                availabilitySlots: [],
                availability: [],
                ratePerHour: sitter["rate"].toDouble(),
                ratingAvg: sitter["rating"],
                ratingCount: sitter["reviews"],
                isAvailable: isAvailable,
                profileImageUrl: sitter["profileImageUrl"],
                galleryImageUrls: [],
                location: const GeoPoint(0, 0),
                reviews: [
                  SitterReview(
                    rating: 5,
                    comment: "Lifesaver! Arrived so quickly.",
                    userId: "Sarah M.",
                  ),
                  SitterReview(
                    rating: 5,
                    comment: "Great with my pets on very short notice.",
                    userId: "Mike T.",
                  ),
                ],
              );
              Navigator.pushNamed(
                context,
                '/sitterProfile',
                arguments: {'sitter': s, 'isEmergency': true},
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(sitter["profileImageUrl"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isAvailable)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sitter["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${sitter["rating"]} ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "(${sitter["reviews"]} reviews)",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "\$${sitter["rate"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Color(0xFFFF416C),
                          ),
                        ),
                        const Text(
                          "/hr",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: isAvailable
                    ? const Color(0xFFF0F9FF)
                    : Colors.grey.withOpacity(0.05),
                child: Row(
                  children: [
                    Icon(
                      isAvailable
                          ? Icons.timer_outlined
                          : Icons.timer_off_outlined,
                      size: 16,
                      color: isAvailable ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAvailable
                          ? "ETA: ${sitter["eta"]}"
                          : "Currently Offline",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isAvailable ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    ...sitter["tags"]
                        .take(1)
                        .map<Widget>(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Priority Standard",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          _buildFeatureRow(
            Icons.verified_user,
            "Certified Caregivers",
            "Specialized training for emergency situations.",
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            Icons.support_agent,
            "24/7 Priority Support",
            "Direct line to our emergency coordination team.",
          ),
          const SizedBox(height: 16),
          _buildFeatureRow(
            Icons.security,
            "Fully Insured",
            "Peace of mind for every urgent booking.",
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFFF416C), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
