import 'package:cloud_firestore/cloud_firestore.dart';

enum MoodType { Happy, Sad, Angry, Neutral, Excited }

class Mood {
  final MoodType type;
  final String note;
  final DateTime date;

  Mood({
    required this.type,
    required this.note,
    required this.date,
  });


  Map<String, dynamic> toFirestore() => {
    'type': type.toString(),
    'note': note,
    'timestamp': Timestamp.fromDate(date),
  };


  factory Mood.fromFirestore(Map<String, dynamic> data) {
    return Mood(
      type: MoodType.values.firstWhere((e) => e.toString() == data['type']),
      note: data['note'] ?? '',
      date: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}