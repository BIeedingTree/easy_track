import 'dart:math';

/// weightLb: User's weight in pounds.
/// sex: male or female.
/// drinks: List of Drink objects representing each drink consumed.
/// currentTime: The current time for calculating elapsed time.
/// 
/// Returns the current BAC as a double.
double calculateCurrentBAC({
  required double weightLb,
  required String sex,
  required List<DateTime> consumptionTimes,
  DateTime? currentTime,
}) {
  final r = (sex.toLowerCase() == 'male') ? 0.68 : 0.55; 

  currentTime ??= DateTime.now();

  const double eliminationRate = 0.015;
  const double standardDrinkGrams = 14.0;
  const double absorptionRatePerMinute = 0.04; // Per minute

  double weightGrams = weightLb * 453.6;
  double totalBAC = 0.0;

  for (var drinkTime in consumptionTimes) {
    // Only consider drinks consumed at or before the current time.
    if (drinkTime.isAfter(currentTime)) {
      continue;
    }

    // Calculate the BAC contribution for this standard drink using the Widmark formula
    // modified with an absorption delay
    int elapsedMinutes = currentTime.difference(drinkTime).inMinutes;
    double absorptionFraction = 1 - exp(-absorptionRatePerMinute * elapsedMinutes);
    double drinkBAC = (standardDrinkGrams / (weightGrams * r)) * absorptionFraction;
    drinkBAC -= eliminationRate * (elapsedMinutes / 60.0);

    drinkBAC = max(0, drinkBAC);

    totalBAC += drinkBAC;
  }
  
  return totalBAC;
}