import 'package:easy_track/utils/current_bac_calculator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';


List<FlSpot> generateBACDataPoints({
  required double weightLb,
  required String sex,
}) {
  List<FlSpot> dataPoints = [];

  var drinksBox = Hive.box<DateTime>('drinksBox');
  if (drinksBox.isEmpty) return dataPoints;

  List<DateTime> consumptionTimes = drinksBox.values.toList();
  consumptionTimes.sort();

  // Start time has 5 minutes added since BAC starts at 0 in the while loop
  DateTime startTime = consumptionTimes.first.add(const Duration(minutes: 5));
  DateTime currentTime = startTime;
  double bac = 0.0;

  // Simulate BAC over time until it reaches 0
  while (bac > 0 || currentTime == startTime) {
    bac = calculateCurrentBAC(
      weightLb: weightLb,
      sex: sex,
      consumptionTimes: consumptionTimes,
      currentTime: currentTime,
    );

    // Time difference in hours
    double hoursSinceStart = currentTime.difference(startTime).inMinutes / 60.0;
    dataPoints.add(FlSpot(hoursSinceStart, bac));

    // Increment time by 5 minutes
    currentTime = currentTime.add(const Duration(minutes: 5));
  }

  return dataPoints;
}