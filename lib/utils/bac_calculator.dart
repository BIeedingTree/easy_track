import 'dart:math';

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
  required DateTime currentTime,
}) {
  // Set the alcohol distribution ratio based on sex.
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

  const double eliminationRate = 0.015;
  const double standardDrinkGrams = 14.0;

  double weightGrams = weightLb * 453.6;
  double totalBAC = 0.0;

  for (var drink in drinks) {
    double hoursElapsed = currentTime.difference(drink.timeConsumed).inMinutes / 60.0;

    // Calculate the BAC contribution for this standard drink using the Widmark formula
    double drinkBAC = (standardDrinkGrams / (weightGrams * r)) * 100 - (eliminationRate * hoursElapsed);

    drinkBAC = max(0, drinkBAC);

    totalBAC += drinkBAC;
  }
  
  return totalBAC;
}