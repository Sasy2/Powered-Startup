import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/vision_test_screen.dart';
import 'screens/exercises_screen_new.dart';
import 'screens/eye_doctor_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/user_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'EyeCon',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF10B2D0),
            brightness: Brightness.light,
          ),
          fontFamily: 'Inter',
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const HomeScreen(),
          '/vision_test': (context) => const VisionTestScreen(),
          '/exercises': (context) => const ExercisesScreenNew(),
          '/chat': (context) => const EyeDoctorScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}