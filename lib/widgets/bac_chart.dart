import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BACChart extends StatelessWidget {
  final List<FlSpot> bacData;

  const BACChart({super.key, required this.bacData});

  @override
  Widget build(BuildContext context) {
    if (bacData.isEmpty) {
      return const Center(child: Text("No BAC data available."));
    }

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                return Text("${value.toStringAsFixed(1)}h",
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.02,
              getTitlesWidget: (value, _) {
                return Text(value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        minX: 0,
        maxX: bacData.last.x,
        minY: 0,
        maxY: bacData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 0.01,
        lineBarsData: [
          LineChartBarData(
            spots: bacData,
            isCurved: true,
            barWidth: 2,
            color: Colors.redAccent,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.redAccent.withValues(alpha: 255*0.3)),
            dotData: const FlDotData(show: false),
          )
        ],
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class BACChart extends StatelessWidget {
//   final List<FlSpot> bacData;
//   final double currentBAC;

//   const BACChart({super.key, required this.bacData, required this.currentBAC});

//   @override
//   Widget build(BuildContext context) {
//     if (bacData.isEmpty) {
//       return const Center(child: Text("No BAC data available."));
//     }

//     return LineChart(
//       LineChartData(
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 1,
//               getTitlesWidget: (value, _) {
//                 // Convert x-axis values (hours) to actual time
//                 final DateTime now = DateTime.now();
//                 final DateTime time = now.add(Duration(minutes: (value * 60).toInt()));
//                 return Text("${time.hour}:${time.minute.toString().padLeft(2, '0')}",
//                     style: const TextStyle(fontSize: 10));
//               },
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 0.02,
//               getTitlesWidget: (value, _) {
//                 return Text(value.toStringAsFixed(2),
//                     style: const TextStyle(fontSize: 10));
//               },
//             ),
//           ),
//         ),
//         minX: 0,
//         maxX: bacData.last.x,
//         minY: 0,
//         maxY: bacData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 0.01,
//         lineBarsData: [
//           LineChartBarData(
//             spots: bacData,
//             isCurved: true,
//             barWidth: 2,
//             color: Colors.redAccent,
//             belowBarData: BarAreaData(
//               show: true,
//               color: Colors.redAccent.withOpacity(0.3),
//             ),
//             dotData: const FlDotData(show: false),
//           ),
//           // Add a horizontal line for current BAC level
//           LineChartBarData(
//             spots: [
//               FlSpot(bacData.first.x, currentBAC),
//               FlSpot(bacData.last.x, currentBAC),
//             ],
//             isCurved: false,
//             barWidth: 1.5,
//             color: Colors.blueAccent,
//             dotData: const FlDotData(show: false),
//           ),
//         ],
//         gridData: const FlGridData(show: true),
//         borderData: FlBorderData(show: true),
//       ),
//     );
//   }
// }
