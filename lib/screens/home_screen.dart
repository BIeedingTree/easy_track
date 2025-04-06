import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../utils/session_service.dart';

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
        actions: [
          if (SessionService.currentSession != null)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _confirmEndSession,
              tooltip: 'End Session',
            ),
        ],
      ),
      body: Center(
        child: SessionService.currentSession == null
            ? _buildStartSessionButton()
            : _buildAddDrinkButton(),
      ),
    );
  }

  Widget _buildStartSessionButton() {
    return ElevatedButton(
      onPressed: _checkUserInfoAndStartSession,
      child: const Text('Start Session'),
    );
  }

  Widget _buildAddDrinkButton() {
    return ElevatedButton(
      onPressed: SessionService.addDrink,
      child: const Text('Add Standard Drink'),
    );
  }

  void _checkUserInfoAndStartSession() {
    final userBox = Hive.box('userBox');
    final weight = userBox.get('weight');
    final sex = userBox.get('sex');

    if (weight == null || sex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete user information first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    SessionService.startSession(weight, sex);
    setState(() {});
  }

  void _confirmEndSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text('Are you sure you want to end the current session?'),
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
