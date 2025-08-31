import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/verification_screen.dart';
import 'screens/homepage_client.dart';
import 'screens/homepage_provider.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(CityToCoastApp());
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
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/verify': (context) => VerificationScreen(),
        '/clientHome': (context) => HomeClientScreen(),
        '/providerHome': (context) => ProviderHomePage(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
