import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _drinkCount = 0; // Tracks the number of drinks
  final List<DateTime> _drinkTimes = []; // Stores timestamps for each drink

  @override
  void initState() {
    super.initState();
    _loadDrinks(); // Load saved drink data when the screen is initialized
  }

  // Load drink count and timestamps from Hive
  Future<void> _loadDrinks() async {
    final box = await Hive.openBox<DateTime>('drinksBox'); // Open Hive box
    final today = DateTime.now();
    final todayDrinks = box.values.where((drink) =>
        drink.year == today.year &&
        drink.month == today.month &&
        drink.day == today.day); // Filter drinks for today

    setState(() {
      _drinkCount = todayDrinks.length; // Update drink count
      _drinkTimes.clear();
      _drinkTimes.addAll(todayDrinks); // Update drink timestamps
    });
  }

  // Add a new drink and save it to Hive
  Future<void> _addDrink() async {
    final now = DateTime.now();
    final box = await Hive.openBox<DateTime>('drinksBox'); // Open Hive box

    await box.add(now); // Save timestamp to Hive
    setState(() {
      _drinkCount += 1;
      _drinkTimes.add(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                '$_drinkCount standard drinks today',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Welcome to Easy Track!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Container(), // Placeholder for BAC graph or other content
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: ElevatedButton(
              onPressed: _addDrink,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Add One Standard Drink'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Index for "Today" tab
        onTap: (index) {
          switch (index) {
            case 0:
              // Do nothing, already on "Today" tab
              break;
            case 1:
              Navigator.pushNamed(context, '/session'); // Navigate to Session Screen
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
