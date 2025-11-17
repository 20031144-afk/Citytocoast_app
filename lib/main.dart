import 'package:citytocoast_app/screens/Authscreen.dart';
import 'package:flutter/material.dart';
import 'screens/verification_screen.dart';
import 'screens/homepage_client.dart';
import 'screens/chat_screen.dart';
import 'screens/sitter.dart';
import 'screens/community_feed.dart';
import 'screens/create_post_screen.dart';
import 'screens/emergency_booking_screen.dart';
import 'screens/emergency_details_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
// import 'screens/favorites_screen.dart';
// import 'screens/my_bookings_screen.dart';

void main() {
  runApp(const CityToCoastApp());
}

class CityToCoastApp extends StatelessWidget {
  const CityToCoastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City to Coast App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/verify': (context) => VerificationScreen(),
        '/clientHome': (context) => HomePageScreen(),
        '/chat': (context) => ChatScreen(),

        // 🔹 Quick Action Routes
        '/communityFeed': (context) => const CommunityFeedScreen(),
        '/createPost': (context) => const CreatePostScreen(),
        '/emergencyBooking': (context) => const EmergencyBookingScreen(),
        '/emergencyDetails': (context) {
          final sitter = ModalRoute.of(context)!.settings.arguments as Sitter;
          return EmergencyDetailsScreen(sitter: sitter);
        },
        // Admin Dashboard
        '/adminDashboard': (context) => const AdminDashboardScreen(),
        // '/favorites': (context) => const FavoritesScreen(),
        // '/myBookings': (context) => const MyBookingsScreen(),
      },
    );
  }
}
