import 'package:easy_track/utils/current_bac_calculator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import '../models/session.dart';
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
  // late Box<Session> sessionsBox;
  late Box userBox;

  bool isTracking = false;
  int drinkCount = 0;

  @override
  void initState() {
    super.initState();
    drinksBox = Hive.box<DateTime>('drinksBox');
    // sessionsBox = Hive.box<Session>('sessionsBox');
    userBox = Hive.box('userBox');
    isTracking = drinksBox.isNotEmpty;
    drinkCount = drinksBox.length;
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

  // Calculate current BAC
  double _calculateMaxBAC({
  required double weightLb,
  required String sex,
  required List<DateTime> consumptionTimes,
  }) {
    if (drinksBox.isEmpty) {
      return 0.0;
    }
    
    double maxBACValue = 0.0;
    DateTime startTime = consumptionTimes.first;
    DateTime endTime = consumptionTimes.last.add(const Duration(minutes: 45));

    // Iterate through time in 5-minute increments from start to extended end time
    for (DateTime currentTime = startTime;
        currentTime.isBefore(endTime);
        currentTime = currentTime.add(const Duration(minutes: 5))) {
      double bac = calculateCurrentBAC(weightLb: weightLb, sex: sex, consumptionTimes: consumptionTimes, currentTime: currentTime);

      if (bac > maxBACValue) {
        maxBACValue = bac;
      }
    }

    return maxBACValue;
  }

  double maxBAC = 0.0;
  
  if (isTracking) {
    final weight = userBox.get('weight');
    final sex = userBox.get('sex');
    if (_isValidUserData(weight, sex)) {
      maxBAC = _calculateMaxBAC(weightLb: double.parse(weight.toString()), sex: sex, consumptionTimes: drinksBox.values.toList());
    }
  }

  // Determine AppBar color based on BAC range
  Color _getAppBarColor(double maxBAC) {
    if (maxBAC >= 0.08) {
      return Colors.red;
    } else if (maxBAC >= 0.04) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('Easy Track'),
      automaticallyImplyLeading: false,
      backgroundColor: _getAppBarColor(maxBAC), // Dynamic AppBar color
    ),

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Easy Track'),
    //     automaticallyImplyLeading: false,
    //     backgroundColor: Colors.green,
    //   ),
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
            
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: isTracking
                        ? SizedBox(
                            height: 300,
                            child: BACChart(bacData: bacData),
                          )
                        : const Text('No active session'),
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
            // case 1:
            //   Navigator.pushNamed(context, '/session'); // Navigate to Session Screen
            //   break;
            case 1:
              Navigator.pushNamed(context, '/user_info');// Navigate to User_Info Screen
              break;
            case 2:
              Navigator.pushNamed(context, '/information'); // Navigate to Information Screen
              break;
          }
        },
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          onPressed: isTracking 
            ? _addDrink
            : _checkUserInfoAndStartSession,
          child: Text(
            isTracking ? 'Add One Standard Drink' : 'Start Session',
            style: const TextStyle(fontSize: 16),
          ),
        ),
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

   void _addDrink() {
    drinksBox.add(DateTime.now()); 

    setState(() {
      drinkCount++; 
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
    // final weight = userBox.get('weight');
    // final sex = userBox.get('sex');

    // if (_isValidUserData(weight, sex)) {
    //   final session = Session.fromDrinks(
    //     weightLb: double.parse(weight.toString()),
    //     sex: sex,
    //   );
    //   sessionsBox.add(session);
    // }
    drinksBox.clear();
    setState(() {
      isTracking = false;
      drinkCount = 0;
    });
  }
  
}
