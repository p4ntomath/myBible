// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/Homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "secret.env");
  await updateDailySong();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      routes: {
        '/homepage': (context) => const Homepage(),
      },
    );
  }
}

Future<void> updateDailySong() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  DateTime initialDate = DateTime(2024, 7, 1);
  String key = 'lastSongUpdate';
  String dailyIndexKey = "dailyIndex";

  if (prefs.containsKey(key)) {
    DateTime lastUpdateDate = DateTime.parse(prefs.getString(key)!);
    int index = daysPassed(lastUpdateDate);

    if (index >= 100) {
      // Reset logic: set new initial date to current date and reset index
      prefs.setString(key, now.toIso8601String());
      index = daysPassed(now); // This should be 0 since the date is reset to now
    }

    prefs.setInt(dailyIndexKey, index % 100); // Ensure the index is always between 0-99
  } else {
    prefs.setString(key, initialDate.toIso8601String());
    int index = daysPassed(initialDate);
    prefs.setInt(dailyIndexKey, index % 100); // Ensure the index is always between 0-99
  }
}

int daysPassed(DateTime initialDate) {
  DateTime now = DateTime.now();
  DateTime normalizedNow = DateTime(now.year, now.month, now.day);
  DateTime normalizedInitialDate = DateTime(initialDate.year, initialDate.month, initialDate.day);
  return normalizedNow.difference(normalizedInitialDate).inDays;
}
