import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:easy_track/utils/bac_graph_util.dart'; // Import the BAC calculator utility
import '../models/session.dart';
import '../widgets/bac_chart.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart for BAC graph

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<DateTime> drinksBox;
  late Box sessionsBox;
  late Box userBox;

  @override
  void initState() {
    super.initState();
    drinksBox = Hive.box<DateTime>('drinksBox');
    sessionsBox = Hive.box('sessionsBox');
    userBox = Hive.box('userBox');
  }

  @override
  Widget build(BuildContext context) {
    bool isTracking = drinksBox.isNotEmpty;

    // Calculate BAC data points when tracking is active
    List<FlSpot> bacData = [];
    if (isTracking) {
      final weight = userBox.get('weight');
      final sex = userBox.get('sex');
      if (weight != null && sex != null) {
          bacData = generateBACDataPoints(
          weightLb: weight,
          sex: sex,
        );
      }
    } 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Track'),
        actions: [
          if (isTracking)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _confirmEndSession,
              tooltip: 'End Session',
            ),
        ],
      ),
      body: Center(
        child: isTracking
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAddDrinkButton(),
                  const SizedBox(height: 20),
                  BACChart(bacData: bacData), // Pass the BAC data to the chart
                ],
              )
            : _buildStartSessionButton(),
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
      onPressed: () {
        drinksBox.add(DateTime.now());
        setState(() {});
      },
      child: const Text('Add Standard Drink'),
    );
  }

  void _checkUserInfoAndStartSession() {
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

    drinksBox.clear();
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
              _endSession();
              Navigator.pop(context);
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }

  void _endSession() {
    final weight = userBox.get('weight');
    final sex = userBox.get('sex');

    if (weight != null && sex != null) {
      final session = Session.fromDrinks(weightLb: weight, sex: sex);
      sessionsBox.add(session);
    }

    drinksBox.clear();
    setState(() {});
  }
}