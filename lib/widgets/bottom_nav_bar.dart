import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex, // Highlight the selected tab
      onTap: (index) {
        if (index != currentIndex) {
          // Only navigate if the selected index is different from the current index
          onTap(index);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
        BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: 'Session'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
      ],
    );
  }
}
