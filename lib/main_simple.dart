import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EyeCon',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B2D0),
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}




