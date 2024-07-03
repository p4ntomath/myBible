// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, must_be_immutable, unused_catch_clause

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/songcard.dart';
import 'data/recommendations.dart';
import 'data/songs.dart';
import 'data/dailySongs.dart';

class MusicHomePage extends StatelessWidget {
  MusicHomePage({super.key});

  late List<Track> tracks;

  late Track track;

  late String artistName;

  late String trackName;

  Future<int> getIndex(List<int> disorderNumbers) async {
    try {
      String dayKey = "dailyIndex";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int ind = prefs.getInt(dayKey) ?? 0; // Provide a default value if the key does not exist

      // Ensure disorderNumbers is not empty and ind is within the valid range
      if (disorderNumbers.isNotEmpty && ind < disorderNumbers.length) {
        return disorderNumbers[ind];
      } else {
        throw Exception("Invalid index or empty disorderNumbers list.");
      }
    } catch (e) {
      final random = Random();
      int randomNumber = random.nextInt(100);
      return randomNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
      ),
      body: FutureBuilder<int>(
        future: getIndex(disorderNumbers),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            int index = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Song Of The Day",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<List<Track>>(
                      future: loadJsonData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No tracks found');
                        } else {
                          tracks = snapshot.data!;
                          track = tracks[index];
                          artistName = track.artistName;
                          trackName = track.trackName;
                          return Column(
                            children: [
                              SongCard(track: track),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecommendationsWidget(
                                        artistName: artistName,
                                        trackName: trackName,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue[100],
                                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Recommendations",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
