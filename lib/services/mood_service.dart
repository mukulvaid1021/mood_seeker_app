import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/mood_model.dart';

class MoodService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Log daily mood
  Future<void> logDailyMood(String userId, Mood mood) async {
    final dateKey = DateFormat('yyyy-MM-dd').format(mood.date);
    await _db
        .collection('users')
        .doc(userId)
        .collection('moods')
        .doc(dateKey)
        .set({
      'type': mood.type.toString(),
      'note': mood.note,
      'timestamp': Timestamp.fromDate(mood.date),
    });
  }

  // Update mood note
  Future<void> updateMoodNote(String userId, DateTime date, String newNote) async {
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    await _db
        .collection('users')
        .doc(userId)
        .collection('moods')
        .doc(dateKey)
        .update({'note': newNote});
  }

  // Get moods for last 7 days
  Future<List<Mood>> getWeeklyMoods(String userId) async {
    final weekAgo = DateTime.now().subtract(Duration(days: 7));
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('moods')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return Mood(
        type: MoodType.values.firstWhere((e) => e.toString() == doc.data()['type']),
        note: doc.data()['note'] ?? '',
        date: (doc.data()['timestamp'] as Timestamp).toDate(),
      );
    }).toList();
  }

  // Get mood insights
  Future<Map<String, dynamic>> getInsights(String userId) async {
    final moods = await getWeeklyMoods(userId);
    final insights = <String, dynamic>{};
    final counts = {
      'Happy': 0,
      'Sad': 0,
      'Angry': 0,
      'Neutral': 0,
    };

    // Calculate mood counts
    for (final mood in moods) {
      counts[mood.type.toString().split('.').last] = counts[mood.type.toString().split('.').last]! + 1;
    }

    insights['happyCount'] = counts['Happy'];
    insights['sadCount'] = counts['Sad'];
    insights['angryCount'] = counts['Angry'];
    insights['neutralCount'] = counts['Neutral'];

    // Most common mood
    final sortedCounts = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    insights['mostCommonMood'] = sortedCounts.first.key;

    // Happy percentage
    insights['happyPercentage'] = moods.isNotEmpty ? (counts['Happy']! / moods.length * 100) : 0;

    // Streak calculation
    insights.addAll(_calculateStreak(moods));

    return insights;
  }

  Map<String, dynamic> _calculateStreak(List<Mood> moods) {
    if (moods.isEmpty) return {'currentStreak': 0, 'streakMood': ''};

    int currentStreak = 1;
    String streakMood = moods.first.type.toString().split('.').last;
    moods.sort((a, b) => b.date.compareTo(a.date));

    for (int i = 1; i < moods.length; i++) {
      if (moods[i].type == moods[i - 1].type) {
        currentStreak++;
      } else {
        break;
      }
    }

    return {
      'currentStreak': currentStreak,
      'streakMood': streakMood,
    };
  }
}