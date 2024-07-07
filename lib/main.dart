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
  String key = 'lastSongUpdate';

  if (prefs.containsKey(key)) {
    DateTime last = DateTime.parse(prefs.getString(key)!);
    print(prefs.getString(key));

    if (isYesterdayOrBefore(last)) {
      String dayKey = "dailyIndex";
      int ind = prefs.getInt(dayKey) ?? -1;
      ind = (ind + 1) % 100; // Cycle through 0 to 99
      prefs.setInt(dayKey, ind);
      prefs.setString(key, now.toIso8601String()); // Update lastSongUpdate to now
    }
  } else {
    prefs.setString(key, now.toIso8601String());
    prefs.setInt('dailyIndex', 0); // Initialize dailyIndex if it doesn't exist
  }
}

bool isYesterdayOrBefore(DateTime date) {
  DateTime now = DateTime.now();
  DateTime normalizedNow = DateTime(now.year, now.month, now.day);
  DateTime normalizedDate = DateTime(date.year, date.month, date.day);
  return normalizedDate.isBefore(normalizedNow);
}
