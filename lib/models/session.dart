import 'package:easy_track/models/drink.dart';
import 'package:easy_track/utils/current_bac_calculator.dart';

class Session {
  final DateTime startTime;
  final DateTime endTime;
  final double maxBAC;
  final double weightLb;
  final String sex;

  Session.fromDrinks({
    required List<Drink> drinks,
    required this.weightLb,
    required this.sex,
  })  : startTime = drinks.isEmpty ? DateTime.now() : drinks.first.timeConsumed,
        endTime = drinks.isEmpty ? DateTime.now() : drinks.last.timeConsumed,
        maxBAC = _calculateMaxBAC(drinks, weightLb, sex);

  static double _calculateMaxBAC(List<Drink> drinks, double weightLb, String sex) {
    if (drinks.isEmpty) return 0.0;

    double maxBACValue = 0.0;
    DateTime extendedEndTime = drinks.last.timeConsumed.add(const Duration(minutes: 90));

    // Iterate through time in 10-minute increments from start to extended end time
    for (DateTime currentTime = drinks.first.timeConsumed;
        currentTime.isBefore(extendedEndTime);
        currentTime = currentTime.add(const Duration(minutes: 10))) {
      double bac = calculateCurrentBAC(weightLb: weightLb, sex: sex, drinks: drinks, currentTime: currentTime);

      if (bac > maxBACValue) {
        maxBACValue = bac;
      }
    }

    return maxBACValue;
  }
}