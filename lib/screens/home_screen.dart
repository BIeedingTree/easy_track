import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Track'),
        backgroundColor: Colors.green,
        actions: [
          if (SessionService.currentSession != null)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _confirmEndSession,
            ),
        ],
      ),
      body: Column(
        children: [
          // BAC Graph
          Expanded(child: _buildBACChart()),
          
          // Session Controls
          _buildSessionButton(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildSessionButton() {
    return SessionService.currentSession == null
        ? ElevatedButton(
            onPressed: _startSession,
            child: const Text('Start Session'),
          )
        : ElevatedButton(
            onPressed: _addDrink,
            child: const Text('Add Standard Drink'),
          );
  }

  void _startSession() {
    if (!_userInfoComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete user info first')));
      return;
    }
    
    SessionService.startSession();
    setState(() {});
  }

  bool _userInfoComplete() {
    final userBox = Hive.box('userBox');
    return userBox.get('weight') != null && userBox.get('sex') != null;
  }

  void _confirmEndSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              SessionService.endSession();
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }
}
