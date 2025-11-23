// lib/screens/root_shell.dart
import 'package:citytocoastv1/UI/screens/book_babysitter_screen.dart';
import 'package:citytocoastv1/UI/screens/contactusscreen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // or whatever you call your main landing page
import 'families_screen.dart'; // you can create these next

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    FamiliesScreen(),
    BookBabysitterScreen(),
    ContactUsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF45A5E0),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care_rounded),
            label: 'Families',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            label: 'Sitters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_emergency_rounded),
            label: 'Contact US',
          ),
        ],
      ),
    );
  }
}
