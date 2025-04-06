import 'package:flutter/material.dart';


void main() {
  runApp(const EasyTrackApp());
}

class EasyTrackApp extends StatelessWidget {
  const EasyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/': (context) => const HomeScreen(), // Home page
        // '/calendar': (context) => const CalendarScreen(), // Calendar page
        // '/user-info': (context) => const UserInfoScreen(), // User info page
        // '/information': (context) => const InformationScreen(), // Info page
        // '/tracking': (context) => const TrackingScreen(), // Tracking functionality
      },
    );
  }
}
