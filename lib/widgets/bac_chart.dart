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
        lineTouchData: const LineTouchData(enabled: false),
      ),
    );
  }
}