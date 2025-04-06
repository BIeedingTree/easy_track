import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Track'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Welcome to Easy Track!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Index for "Today" tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/'); // Navigate to Home Screen
              break;
            case 1:
              Navigator.pushNamed(context, '/calendar'); // Navigate to Calendar Screen
              break;
            case 2:
              Navigator.pushNamed(context, '/user-info'); // Navigate to User Info Screen
              break;
            case 3:
              Navigator.pushNamed(context, '/information'); // Navigate to Information Screen
              break;
          }
        },
      ),
    );
  }
}
