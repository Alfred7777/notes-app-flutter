import 'package:flutter/material.dart';
import 'package:notes_app/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      home: const HomeScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark, 
          primary: Colors.blueGrey.shade900, 
          onPrimary: Colors.grey.shade100, 
          secondary: Colors.teal.shade600, 
          onSecondary: Colors.grey.shade100, 
          error: Colors.red.shade800, 
          onError: Colors.grey.shade100, 
          background: Colors.blueGrey.shade800, 
          onBackground: Colors.grey.shade100, 
          surface: Colors.blueGrey.shade900, 
          onSurface: Colors.grey.shade100,
        ),
        scaffoldBackgroundColor: Colors.blueGrey.shade800,
        dialogBackgroundColor: Colors.blueGrey.shade800,
        fontFamily: 'Montserrat',
      ),
    );
  }
}

