// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'songs.dart';

const String clientId = 'bd52ae0dda914329b1a8c088f8b15a41';
const String clientSecret = 'e89e20bec02a4e898ff44cf523345580';


class RecommendationsWidget extends StatefulWidget {
  final String artistName;
  final String trackName;

  RecommendationsWidget({required this.artistName, required this.trackName});

  @override
  _RecommendationsWidgetState createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  late Future<List<Track>> _recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = fetchRecommendations();
  }

  Future<List<Track>> fetchRecommendations() async {
    final String accessToken = await getAccessToken();
    final String trackId = await getTrackId(accessToken, widget.trackName, widget.artistName);
    final List<Track> recommendations = await getRecommendations(accessToken, trackId);
    return recommendations;
  }

  Future<String> getAccessToken() async {
    final String authHeader = base64Encode(utf8.encode('$clientId:$clientSecret'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Authorization': 'Basic $authHeader'},
      body: {'grant_type': 'client_credentials'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> tokenInfo = json.decode(response.body);
      return tokenInfo['access_token'];
    } else {
      throw Exception('Failed to retrieve access token');
    }
  }

  Future<String> getTrackId(String accessToken, String trackName, String artistName) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=track:$trackName%20artist:$artistName&type=track&limit=1'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> searchResults = json.decode(response.body);
      final tracks = searchResults['tracks']['items'];
      if (tracks.isNotEmpty) {
        return tracks[0]['id'];
      } else {
        throw Exception('Track not found');
      }
    } else {
      throw Exception('Failed to retrieve track ID');
    }
  }

  Future<List<Track>> getRecommendations(String accessToken, String trackId) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/recommendations?seed_tracks=$trackId&limit=20'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> recommendations = json.decode(response.body);
      return (recommendations['tracks'] as List)
          .map((track) => Track(
                trackName: track['name'],
                artistName: track['artists'][0]['name'],
                albumImageUrl: track['album']['images'][0]['url'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Failed to retrieve recommendations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: Text("Recommendations"),
        centerTitle: true,
      ),
      body: Center(
      child: FutureBuilder<List<Track>>(
        future: _recommendationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No recommendations found');
          } else {
            final recommendations = snapshot.data!;
            return ListView.builder(
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final track = recommendations[index];
                return ListTile(
                  title: Text(track.trackName),
                  subtitle: Text(track.artistName),
                  leading: Image.network(track.albumImageUrl),
                );
              },
            );
          }
        },
      ),
    ),
    );
  }
}
