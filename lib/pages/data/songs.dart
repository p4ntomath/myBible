import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Track {
  final String trackName;
  final String artistName;
  final String albumImageUrl;

  Track({
    required this.trackName,
    required this.artistName,
    required this.albumImageUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      trackName: json['track_name'],
      artistName: json['artist_name'],
      albumImageUrl: json['album_image_url'],
    );
  }
}

Future<List<Track>> loadJsonData() async {
  // Load the JSON file from the assets folder
  String jsonString = await rootBundle.loadString('assets/tracks.json');
  // Parse the JSON string
  List<dynamic> jsonList = jsonDecode(jsonString);
  // Map JSON objects to Track objects
  List<Track> tracks = jsonList.map((json) => Track.fromJson(json)).toList();

  return tracks;
}
