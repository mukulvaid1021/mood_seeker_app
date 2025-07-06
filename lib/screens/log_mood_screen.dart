import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/mood_model.dart';
import '../services/mood_service.dart';

class LogMoodScreen extends StatefulWidget {
  @override
  _LogMoodScreenState createState() => _LogMoodScreenState();
}

class _LogMoodScreenState extends State<LogMoodScreen> {
  final _formKey = GlobalKey<FormState>();
  MoodType _selectedMood = MoodType.Neutral;
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Log Your Mood'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How are you feeling today?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // Emoji Preview
                  Center(
                    child: Text(
                      _getMoodEmoji(_selectedMood),
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mood Dropdown
                  DropdownButtonFormField<MoodType>(
                    value: _selectedMood,
                    items: MoodType.values.map((mood) {
                      return DropdownMenuItem(
                        value: mood,
                        child: Text(mood.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedMood = value!),
                    decoration: const InputDecoration(
                      labelText: 'Select Mood',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.emoji_emotions),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Note Field
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.notes),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 30),

                  // Save Button
                  ElevatedButton.icon(
                    onPressed: _logMood,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Mood'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMoodEmoji(MoodType mood) {
    switch (mood) {
      case MoodType.Happy:
        return "😄";
      case MoodType.Sad:
        return "😢";
      case MoodType.Angry:
        return "😡";
      case MoodType.Excited:
        return "🤩";
      case MoodType.Neutral:
      default:
        return "😐";
    }
  }

  Future<void> _logMood() async {
    if (_formKey.currentState!.validate()) {
      final mood = Mood(
        type: _selectedMood,
        note: _noteController.text,
        date: DateTime.now(),
      );

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await MoodService().logDailyMood(userId, mood);
        Fluttertoast.showToast(msg: 'Mood logged successfully');
        Navigator.pop(context);
      }
    }
  }
}
