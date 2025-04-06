import 'package:hive/hive.dart';
import 'package:easy_track/utils/current_bac_calculator.dart';

class Session {
  final DateTime startTime;
  final DateTime endTime;
  final double maxBAC;
  final double weightLb;
  final String sex;

  Session({
  required this.startTime,
  required this.endTime,
  required this.maxBAC,
  required this.weightLb,
  required this.sex,
});

  Session.fromDrinks({
    required this.weightLb,
    required this.sex,
  })  : startTime = _getStartTime(),
        endTime = _getEndTime(),
        maxBAC = _calculateMaxBAC(weightLb, sex);
  
  static DateTime _getStartTime() {
    var drinksBox = Hive.box<DateTime>('drinksBox');
    if (drinksBox.isEmpty) {
      return DateTime.now();
    }
    List<DateTime> consumptionTimes = drinksBox.values.toList();
    consumptionTimes.sort();
    return consumptionTimes.first; 
  }

  static DateTime _getEndTime() {
    var drinksBox = Hive.box<DateTime>('drinksBox');
    if (drinksBox.isEmpty) {
      return DateTime.now(); 
    }
    List<DateTime> consumptionTimes = drinksBox.values.toList();
    consumptionTimes.sort();
    return consumptionTimes.last;
  }

  static double _calculateMaxBAC(double weightLb, String sex) {
    var drinksBox = Hive.box<DateTime>('drinksBox');
    if (drinksBox.isEmpty) return 0.0;

    double maxBACValue = 0.0;
    List<DateTime> consumptionTimes = drinksBox.values.toList();
    consumptionTimes.sort();

    DateTime extendedEndTime = consumptionTimes.last.add(const Duration(minutes: 90));

    // Iterate through time in 5-minute increments from start to extended end time
    for (DateTime currentTime = consumptionTimes.first;
        currentTime.isBefore(extendedEndTime);
        currentTime = currentTime.add(const Duration(minutes: 5))) {
      double bac = calculateCurrentBAC(weightLb: weightLb, sex: sex, consumptionTimes: consumptionTimes, currentTime: currentTime);

      if (bac > maxBACValue) {
        maxBACValue = bac;
      }
    }

    return maxBACValue;
  }
}


