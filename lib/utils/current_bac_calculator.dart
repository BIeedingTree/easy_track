import 'dart:math';

/// weightLb: User's weight in pounds.
/// sex: male or female.
/// drinks: List of Drink objects representing each drink consumed.
/// currentTime: The current time for calculating elapsed time.
/// 
/// Returns the current BAC as a double using a modified Widmark formula
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
  double totalAbsorbedAlcohol  = 0.0;

  // Sum the absorbed alcohol for each drink
  for (var drinkTime in consumptionTimes) {
    if (drinkTime.isAfter(currentTime)) continue;

    int elapsedMinutes = currentTime.difference(drinkTime).inMinutes;
    // Calculate the fraction of alcohol absorbed at this time
    double absorptionFraction = 1 - exp(-absorptionRatePerMinute * elapsedMinutes);
    totalAbsorbedAlcohol += standardDrinkGrams * absorptionFraction;
  }

  double bacWithoutElimination = (totalAbsorbedAlcohol / (weightGrams * r)) * 100;

  int totalElapsedMinutes = currentTime.difference(consumptionTimes.first).inMinutes;
  double elimination = eliminationRate * (totalElapsedMinutes / 60.0);

  double bac = bacWithoutElimination - elimination;

  return max(0, bac);
}