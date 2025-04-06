import 'package:easy_track/models/drink.dart';
import 'package:easy_track/utils/current_bac_calculator.dart';

class Session {
  final DateTime startTime;
  final DateTime endTime;
  final double maxBAC;

  Session.fromDrinks(List<Drink> drinks)
      : startTime = drinks.isEmpty ? DateTime.now() : drinks.first.timeConsumed,
        endTime = drinks.isEmpty ? DateTime.now() : drinks.last.timeConsumed,
        maxBAC = _calculateMaxBAC(drinks);

  static double _calculateMaxBAC(List<Drink> drinks) {
    double maxBACValue = 0.0;

    for (var drink in drinks) {
      // Simulate BAC calculation at each drink (you could integrate the actual BAC calculation logic here)
      double bac = calculateCurrentBAC(weightLb: 150, sex: "male", drinks: [Drink(timeConsumed: DateTime(2025, 5, 20, 0))]);
      
      if (bac > maxBACValue) {
        maxBACValue = bac;
      }
    }

    return maxBACValue; // Return the time at which max BAC occurred
  }
}