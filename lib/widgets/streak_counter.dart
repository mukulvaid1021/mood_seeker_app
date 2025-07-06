import 'package:flutter/material.dart';

class StreakCounter extends StatelessWidget {
  final int streak;
  final String mood;

  StreakCounter({required this.streak, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$streak',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'days in a row',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 4),
        Text(
          'being $mood',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}