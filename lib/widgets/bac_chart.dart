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
                return Text("${value.toStringAsFixed(1)}h",
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: 0.02,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 8),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
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