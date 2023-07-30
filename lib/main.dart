import 'package:flutter/material.dart';
import 'package:notes_app/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notes App',
      home: HomeScreen(),
    );
  }
}

