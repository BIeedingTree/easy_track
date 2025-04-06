import 'package:flutter/material.dart';
import 'package:easy_track/screens/home_screen.dart';
// import 'package:easy_track/screens/calendar.dart';
// import 'package:easy_track/screens/information.dart';
import 'package:easy_track/screens/user-info.dart';

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
        '/': (context) => const HomeScreen(), // Home page
        // '/calendar': (context) => const CalendarScreen(), // Calendar page
        '/user-info': (context) => const UserInfoScreen(), // User info page
        // '/information': (context) => const InformationScreen(), // Info page
        // '/tracking': (context) => const TrackingScreen(), // Tracking functionality
      },
    );
  }
}
