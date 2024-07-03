// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/Homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  String key = 'lastSongUpdate';

  if (prefs.containsKey(key)) {
    DateTime last = DateTime.parse(prefs.getString(key)!);

    if (isYesterdayOrBefore(last)) {
      String dayKey = "dailyIndex";

      if (prefs.containsKey(dayKey)) {
        int ind = prefs.getInt(dayKey)!;

        if (ind + 1 == 100) {
          ind = 0;
        }

        prefs.setInt(dayKey, ind + 1);
      } else {
        prefs.setInt(dayKey, 0);
      }
    }
  } else {
    prefs.setString(key, now.toIso8601String());
  }
}

bool isYesterdayOrBefore(DateTime dateTime) {
  DateTime today = DateTime.now();
  DateTime yesterday = today.subtract(Duration(days: 1));

  // Check if dateTime is before yesterday or is yesterday
  if (dateTime.isBefore(yesterday) || dateTime.isAtSameMomentAs(yesterday)) {
    return true;
  }
  // Check if dateTime is today
  if (dateTime.isAtSameMomentAs(today)) {
    return false;
  }
  // If dateTime is after today
  return false;
}
