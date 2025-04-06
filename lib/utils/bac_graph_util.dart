import 'package:easy_track/models/drink.dart';
import 'package:easy_track/utils/current_bac_calculator.dart';
import 'package:fl_chart/fl_chart.dart';

List<FlSpot> generateBACDataPoints({
  required double weightLb,
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
      weightLb: weightLb,
      sex: sex,
      drinks: drinks,
      currentTime: currentTime,
    );

    // Time difference in hours from the start time
    double hoursSinceStart = currentTime.difference(startTime).inMinutes / 60.0;
    dataPoints.add(FlSpot(hoursSinceStart, bac));

    // Increment time by 5 minutes
    currentTime = currentTime.add(const Duration(minutes: 5));
  }

  return dataPoints;
}