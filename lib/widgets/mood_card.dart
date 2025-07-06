import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_model.dart';

class MoodCard extends StatelessWidget {
  final Mood mood;
  final VoidCallback onTap;

  MoodCard({required this.mood, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: _getMoodColor(mood.type),
      child: ListTile(
        title: Text(
          mood.type.toString().split('.').last,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: mood.note.isNotEmpty
            ? Text(
          mood.note,
          style: TextStyle(color: Colors.white70),
        )
            : null,
        trailing: Text(
          DateFormat('MMM d').format(mood.date),
          style: TextStyle(color: Colors.white),
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getMoodColor(MoodType type) {
    switch (type) {
      case MoodType.Happy:
        return Colors.green;
      case MoodType.Sad:
        return Colors.blue;
      case MoodType.Angry:
        return Colors.red;
      case MoodType.Neutral:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}