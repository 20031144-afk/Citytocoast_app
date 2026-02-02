import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'UI/screens/root_shell.dart';

void main() {
  runApp(const CityToCoastApp());
}

class CityToCoastApp extends StatelessWidget {
  const CityToCoastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City to Coast Sitting',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const RootShell(),
    );
  }
}
