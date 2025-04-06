import 'package:easy_track/models/session.dart';
import 'package:flutter/material.dart';
import 'package:easy_track/screens/home_screen.dart';
import 'package:easy_track/screens/sessions.dart';
// import 'package:easy_track/screens/information.dart';
import 'package:easy_track/screens/user_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('userBox');
  await Hive.openBox<DateTime>('drinksBox');
  await Hive.openBox<Session>('sessionsBox');

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
        '/sessions': (context) => const SessionScreen(),
        '/user_info': (context) => const UserInfoScreen(), // User info page
        // '/information': (context) => const InformationScreen(), // Info page
        // '/tracking': (context) => const TrackingScreen(), // Tracking functionality
      },
    );
  }
}
