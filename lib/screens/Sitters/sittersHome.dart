import 'package:citytocoast_app/screens/Authscreen.dart';
import 'package:citytocoast_app/screens/Sitters/manageAvailability.dart';
import 'package:citytocoast_app/screens/Sitters/sitterEditProfile.dart';
import 'package:citytocoast_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SitterDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String uid;

  const SitterDashboardScreen({
    super.key,
    required this.userData,
    required this.uid,
  });

  @override
  State<SitterDashboardScreen> createState() => _SitterDashboardScreenState();
}

class _SitterDashboardScreenState extends State<SitterDashboardScreen> {
  bool isAvailable = true;

  @override
  void initState() {
    super.initState();
    // Initialize isAvailable from passed data if present, otherwise default to true
    if (widget.userData.containsKey('isAvailable')) {
      isAvailable = widget.userData['isAvailable'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 16),
            _availabilityCard(),
            const SizedBox(height: 16),
            _todaysBookings(),
            const SizedBox(height: 16),
            _upcomingBookings(),
            const SizedBox(height: 20),
            _quickActions(),
            const SizedBox(height: 16),
            _earningsCard(),
            const SizedBox(height: 16),
            _reviewsCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFF5B5FEF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${widget.userData['firstName'] ?? 'Sitter'} 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Here's your schedule today",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              print('Logout pressed');
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ================= AVAILABILITY =================
  Widget _availabilityCard() {
    return _card(
      child: SwitchListTile(
        title: const Text(
          'Availability Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: const [
            Icon(Icons.circle, color: Colors.green, size: 10),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'You are available for bookings',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        value: isAvailable,
        activeColor: Colors.green,
        onChanged: (value) async {
          final isProfileCompleted =
              widget.userData['isProfileCompleted'] == true;

          if (!isProfileCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Please complete your profile to enable availability.",
                ),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }

          setState(() => isAvailable = value);

          try {
            // Update only the 'isAvailable' field in the 'sitters' collection
            await FirebaseFirestore.instance
                .collection('sitters')
                .doc(widget.uid)
                .update({'isAvailable': value});
            print(value ? 'Availability ON' : 'Availability OFF');
          } catch (e) {
            print("Error updating availability: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to update status: $e")),
            );
          }
        },
      ),
    );
  }

  // ================= TODAY BOOKINGS =================
  Widget _todaysBookings() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Bookings",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _bookingRow(
            '9:00 AM – 1:00 PM',
            'Baby Care',
            'Confirmed',
            Colors.green,
            () => print("Today's booking pressed"),
          ),

          const SizedBox(height: 10),

          _bookingRow(
            '3:00 PM – 6:00 PM',
            'Pet Care',
            'Pending',
            Colors.orange,
            () => print("Today's booking pressed"),
          ),
        ],
      ),
    );
  }

  // ================= UPCOMING BOOKINGS =================
  Widget _upcomingBookings() {
    return _card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Bookings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => print('See all pressed'),
                child: const Text(
                  'See all',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _upcomingRow(
            'Jan 12 · 10:00 AM',
            '123 Oak Street',
            'Confirmed',
            Colors.green,
          ),
          _upcomingRow(
            'Jan 14 · 2:00 PM',
            '456 Maple Avenue',
            'Confirmed',
            Colors.green,
          ),
          _upcomingRow(
            'Jan 15 · 9:00 AM',
            '789 Pine Road',
            'Pending',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  // ================= EARNINGS =================
  Widget _earningsCard() {
    return GestureDetector(
      onTap: () => print('Earnings card pressed'),
      child: _card(
        child: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Color(0xFFE8FFF0),
              child: Icon(Icons.attach_money, color: Colors.green),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$320',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text('This Week'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= REVIEWS =================
  Widget _reviewsCard() {
    return GestureDetector(
      onTap: () => print('Reviews card pressed'),
      child: _card(
        child: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Color(0xFFFFF9E6),
              child: Icon(Icons.star, color: Colors.amber),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        '/ 5.0',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Text('124 Reviews'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= QUICK ACTIONS =================
  Widget _quickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _actionCard(
                Icons.schedule,
                'Manage Availability',
                'Set your working hours',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAvailability(),
                    ),
                  );
                },
              ),
              _actionCard(
                Icons.calendar_today,
                'View Bookings',
                'Upcoming & past jobs',
                () => print('Bookings pressed'),
              ),
              _actionCard(
                Icons.account_balance_wallet,
                'Earnings',
                'Track your income',
                () => print('Earnings pressed'),
              ),
              _actionCard(
                Icons.person,
                'Edit Profile',
                'Update your details',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SitterEditProfile(
                        userData: widget.userData,
                        uid: widget.uid,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= REUSABLE WIDGETS =================
  Widget _card({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _bookingRow(
    String time,
    String type,
    String status,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(type),
              ],
            ),
            Chip(
              label: Text(status),
              backgroundColor: color.withOpacity(0.15),
              labelStyle: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _upcomingRow(String date, String address, String status, Color color) {
    return GestureDetector(
      onTap: () => print('Upcoming booking pressed'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(address),
                  ],
                ),
              ],
            ),
            Chip(
              label: Text(status),
              backgroundColor: color.withOpacity(0.15),
              labelStyle: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFEAF2FF),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
