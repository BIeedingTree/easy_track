import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';
import '../widgets/bac_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:easy_track/utils/bac_graph_util.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<DateTime> drinksBox;
  late Box<Session> sessionsBox;
  late Box userBox;

  bool isTracking = false;
  int drinkCount = 0;

  @override
  void initState() {
    super.initState();
    drinksBox = Hive.box<DateTime>('drinksBox');
    sessionsBox = Hive.box<Session>('sessionsBox');
    userBox = Hive.box('userBox');
  }

  @override
  Widget build(BuildContext context) {
    // Calculate BAC data points when tracking is active
    List<FlSpot> bacData = [];
    if (isTracking) {
      final weight = userBox.get('weight');
      final sex = userBox.get('sex');
      if (_isValidUserData(weight, sex)) {
          bacData = generateBACDataPoints(
          weightLb: double.tryParse(weight.toString()) ?? 0.0,
          sex: sex,
        ).where((spot) => spot.y.isFinite).toList();
      }
    } 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Track'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top row with End Session and Drink Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isTracking)
                  TextButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('End Session'),
                    onPressed: _confirmEndSession,
                  )
                else
                  const SizedBox(), // Empty placeholder when not tracking
                
                if (isTracking)
                  Text(
                    '$drinkCount drinks today',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                else
                  const SizedBox(), // Empty placeholder when not tracking
              ],
            ),
            
            // Middle - BAC Chart
            Expanded(
              child: isTracking 
                ? BACChart(bacData: bacData)
                : const Center(child: Text('No active session')),
            ),
            
            // Bottom - Add Drink or Start Session button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: isTracking 
                    ? () {
                        drinksBox.add(DateTime.now());
                        setState(() {});
                      }
                    : _checkUserInfoAndStartSession,
                  child: Text(
                    isTracking ? 'Add One Standard Drink' : 'Start Session',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Index for "User Info" tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/'); // Navigate to Home Screen
              break;
            case 1:
              Navigator.pushNamed(context, '/session'); // Navigate to Session Screen
              break;
            case 2:
              Navigator.pushNamed(context, '/user_info');// Navigate to User_Info Screen
              break;
            case 3:
              Navigator.pushNamed(context, '/information'); // Navigate to Information Screen
              break;
          }
        },
      ),
    );
  }

  bool _isValidUserData(dynamic weight, dynamic sex) {
    return weight != null &&
        double.tryParse(weight.toString()) != null &&
        double.parse(weight.toString()) > 0 &&
        sex != null &&
        ['male', 'female'].contains(sex.toString().toLowerCase());
  }

  void _checkUserInfoAndStartSession() {
    final weight = userBox.get('weight');
    final sex = userBox.get('sex');

    if (!_isValidUserData(weight, sex)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete user information first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      isTracking = true; // Set tracking flag to true
      drinkCount = 0; // Reset drink count for the new session
    });
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

    if (_isValidUserData(weight, sex)) {
      final session = Session.fromDrinks(
        weightLb: double.parse(weight.toString()),
        sex: sex,
      );
      sessionsBox.add(session);
    }
    drinksBox.clear();
    setState(() {
      isTracking = false;
      drinkCount = 0;
    });
  }
  
}
