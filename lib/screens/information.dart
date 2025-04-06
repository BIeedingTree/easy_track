import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1
              const Text(
                'Easy Track Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Easy Track is an alcohol tracking app that tracks your Blood Alcohol Content (BAC) over a drinking session. '
                'Tracking your BAC is important for understanding your level of intoxication. Once your BAC reaches 0.08, you are '
                'over the legal limit, are at a reduced ability to process information, and have a risk of injury.',
                style: TextStyle(fontSize: 15.2),
              ),
              const SizedBox(height: 20),

              // Section 2
              const Text(
                'How to Use Easy Track',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please input your weight and sex information for Easy Track to algorithmically calculate your BAC. Simply click the "Start Session" '
                'button to start tracking, and add standard drinks when you drink them. Click End Session when you are finished. Easy Track will display your BAC curve and '
                'indicate your level of intoxication using color coding. Green indicates a BAC of 0.00-0.04, yellow indicates a BAC of 0.04-0.08, and red indicates a BAC of 0.08 or higher.',
                style: TextStyle(fontSize: 15.2),
              ),
              const SizedBox(height: 20),

              // Section 3
              const Text(
                'Guidelines for Standard Drinks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '- Liquor/Spirits: 1 shot or 1.5 oz\n'
                '- Wine: Half a cup or 5 oz\n'
                '- Beer: 1 can or 12 oz',
                style: TextStyle(fontSize: 15.2),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Index for "Information" tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/'); // Navigate to Home Screen
              break;
            // case 1:
            //   Navigator.pushNamed(context, '/session'); // Navigate to Session Screen
            //   break;
            case 1:
              Navigator.pushNamed(context, '/user_info'); // Navigate to User Info Screen
              break;
            case 2:
              // current page
              break;
          }
        },
      ),
    );
  }
}
