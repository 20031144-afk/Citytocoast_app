// lib/screens/root_shell.dart
import 'package:citytocoastv1/UI/screens/contactus_screen.dart';
import 'package:citytocoastv1/UI/screens/joinourteam_screen.dart';
import 'package:citytocoastv1/UI/screens/pet_sitting_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // or whatever you call your main landing page
import 'families_screen.dart'; // you can create these next
// import 'sitters_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  final _screens = const [HomeScreen(), FamiliesScreen(), PetSittingScreen(), JoinOurTeam(), ContactUsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
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
            icon: Icon(Icons.group_add_rounded),
            label: 'Join our team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail_rounded),
            label: 'Contact Us',
          ),
        ],
      ),
    );
  }
}
