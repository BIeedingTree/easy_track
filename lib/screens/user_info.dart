import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../widgets/bottom_nav_bar.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _weightController = TextEditingController();
  String? _selectedSex;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Load saved user information from Hive
  Future<void> _loadUserInfo() async {
    final box = Hive.box('userBox');
    setState(() {
      final weight = box.get('weight', defaultValue: null) as int?;
      _weightController.text = weight != null ? weight.toString() : '';
      _selectedSex = box.get('sex', defaultValue: null) as String?;
    });
  }

  // Save user information to Hive
  Future<void> _saveUserInfo() async {
    final weight = int.tryParse(_weightController.text);

    if (weight == null || _selectedSex == null) {
      // Show an error message if any field is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final box = Hive.box('userBox');
    await box.put('weight', weight); // Save weight as an int
    await box.put('sex', _selectedSex);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User information saved successfully!'),
        backgroundColor: Color.fromARGB(255, 3, 100, 13),
      ),
    );

    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Weight Input Field (Pounds)
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (lbs)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
              ),
              const SizedBox(height: 20),

              // Sex Selection Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSex,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSex = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Sex',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 40),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserInfo,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Index for "User Info" tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/'); // Navigate to Home Screen
              break;
            case 1:
              // Do nothing since this is the current page 
              break;
            case 2:
              Navigator.pushNamed(context, '/information'); // Navigate to Information Screen
              break;
          }
        },
      ),
    );
  }
}
