import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomPieChart extends StatelessWidget {
  final List<PieData> data; // list of values & labels
  final double centerSpaceRadius;
  final double sectionRadius;

  const CustomPieChart({
    super.key,
    required this.data,
    this.centerSpaceRadius = 80,
    this.sectionRadius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: centerSpaceRadius,
        sectionsSpace: 2,
        sections: data.map((e) {
          return PieChartSectionData(
            value: e.value,
            title: "${e.value.toInt()}%", // show percentage
            color: e.color,
            radius: sectionRadius,
            titleStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Model class for pie chart values
class PieData {
  final double value;
  final Color color;

  PieData({required this.value, required this.color});
}
