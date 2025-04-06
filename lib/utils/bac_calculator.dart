import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class Drink {
  final DateTime timeConsumed;

  Drink({
    required this.timeConsumed,
  });
}

/// weightLb: User's weight in pounds.
/// sex: male or female.
/// drinks: List of Drink objects representing each drink consumed.
/// currentTime: The current time for calculating elapsed time.
/// 
/// Returns the current BAC as a double.
double calculateCurrentBAC({
  required double weightLb,
  required String sex,
  required List<Drink> drinks,
  DateTime? currentTime,
}) {
  double r;
  if (sex == 'male') {
    r = 0.68;
  } 
  else if (sex.toLowerCase() == 'female') {
    r = 0.55;
  } 
  else {
    r = 0.615;
  }

  currentTime ??= DateTime.now();

  const double eliminationRate = 0.015;
  const double standardDrinkGrams = 14.0;

  double weightGrams = weightLb * 453.6;
  double totalBAC = 0.0;

  for (var drink in drinks) {
    // Only consider drinks consumed at or before the current time.
    if (drink.timeConsumed.isAfter(currentTime)) {
      continue;
    }

    double hoursElapsed = currentTime.difference(drink.timeConsumed).inMinutes / 60.0;

    // Calculate the BAC contribution for this standard drink using the Widmark formula
    double drinkBAC = (standardDrinkGrams / (weightGrams * r)) * 100 - (eliminationRate * hoursElapsed);

    drinkBAC = max(0, drinkBAC);

    totalBAC += drinkBAC;
  }
  
  return totalBAC;
}

List<FlSpot> generateBACDataPoints({
  required double weightKg,
  required String sex,
  required List<Drink> drinks,
}) {
  List<FlSpot> dataPoints = [];
  if (drinks.isEmpty) return dataPoints;

  // Sort drinks by time consumed
  drinks.sort((a, b) => a.timeConsumed.compareTo(b.timeConsumed));

  // Start time is the time of the first drink
  DateTime startTime = drinks.first.timeConsumed;
  DateTime currentTime = startTime;
  double bac = 0.0;

  // Simulate BAC over time until it reaches 0
  while (bac > 0 || currentTime == startTime) {
    bac = calculateCurrentBAC(
      weightLb: weightKg * 2.205, // Convert kg to lbs
      sex: sex,
      drinks: drinks,
      currentTime: currentTime,
    );

    // Time difference in hours from the start time
    double hoursSinceStart = currentTime.difference(startTime).inMinutes / 60.0;
    dataPoints.add(FlSpot(hoursSinceStart, bac));

    // Increment time by 5 minutes
    currentTime = currentTime.add(Duration(minutes: 5));
  }

  return dataPoints;
}