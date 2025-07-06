import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodPieChart extends StatelessWidget {
  final Map<String, dynamic> insights;

  const MoodPieChart({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final moodData = [
      {
        'type': 'Happy',
        'count': (insights['happyCount'] ?? 0) as int,
        'color': Colors.green,
      },
      {
        'type': 'Sad',
        'count': (insights['sadCount'] ?? 0) as int,
        'color': Colors.blue,
      },
      {
        'type': 'Angry',
        'count': (insights['angryCount'] ?? 0) as int,
        'color': Colors.red,
      },
      {
        'type': 'Neutral',
        'count': (insights['neutralCount'] ?? 0) as int,
        'color': Colors.grey,
      },
    ];

    final total = moodData.fold<int>(0, (sum, item) => sum + (item['count'] as int));

    if (total == 0) {
      return Center(child: Text('No mood data to display.'));
    }

    return PieChart(
      PieChartData(
        sections: moodData.map((mood) {
          final int count = mood['count'] as int;
          final double percentage = (count / total) * 100;

          return PieChartSectionData(
            color: mood['color'] as Color,
            value: count.toDouble(),
            title: '${mood['type']} (${percentage.toStringAsFixed(1)}%)',
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            titlePositionPercentageOffset: 0.6,
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 30,
      ),
    );
  }
}
