import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mood_seeker/screens/auth/login_screen.dart';
import 'package:mood_seeker/screens/auth/register_screen.dart';
import 'package:mood_seeker/screens/history_screen.dart';
import 'package:mood_seeker/screens/insights_screen.dart';
import 'package:mood_seeker/screens/log_mood_screen.dart';
import 'package:mood_seeker/widgets/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBqG2eVThg4x5jV3hHr9zrJOgBisanJGCA",
        authDomain: "fire-setup-f2a80.firebaseapp.com",
        projectId: "fire-setup-f2a80",
        storageBucket: "fire-setup-f2a80.firebasestorage.app",
        messagingSenderId: "819420359302",
        appId: "1:819420359302:web:5d19734adec8636249ff07",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/auth-check',
      routes: {
        '/auth-check': (context) =>
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return snapshot.hasData ? HomeScreen() : LoginScreen();
              },
            ),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/log-mood': (context) => LogMoodScreen(),
        '/history': (context) => HistoryScreen(),
        '/insights': (context) => InsightsScreen(),
      },
    );
  }
}