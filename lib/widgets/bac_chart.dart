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

    final double maxY = bacData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 0.01;
    const int yLabelCount = 10;
    final double yInterval = maxY / yLabelCount;

    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text("${value.round()}h", style: const TextStyle(fontSize: 12));
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(3),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
        ),
        minX: 0,
        maxX: bacData.last.x,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: bacData,
            isCurved: true,
            barWidth: 2,
            color: Colors.redAccent,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.redAccent.withOpacity(0.3),
            ),
            dotData: const FlDotData(show: false),
          )
        ],
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}