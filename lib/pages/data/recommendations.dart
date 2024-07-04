// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

String clientId = '${dotenv.env['CLIENTID']}';
String clientSecret = '${dotenv.env['CLIENTSECRET']}';

class RecommendationsWidget extends StatefulWidget {
  final String artistName;
  final String trackName;

  RecommendationsWidget({required this.artistName, required this.trackName});

  @override
  _RecommendationsWidgetState createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  late Future<List<Song>> _recommendationsFuture;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingUrl;

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = fetchRecommendations();
  }

  Future<List<Song>> fetchRecommendations() async {
    final String accessToken = await getAccessToken();
    final String trackId =
        await getTrackId(accessToken, widget.trackName, widget.artistName);
    final List<Song> recommendations =
        await getRecommendations(accessToken, trackId);
    return recommendations;
  }

  Future<String> getAccessToken() async {
    final String authHeader =
        base64Encode(utf8.encode('$clientId:$clientSecret'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $authHeader',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> tokenInfo = json.decode(response.body);
      return tokenInfo['access_token'];
    } else {
      throw Exception('Failed to retrieve access token');
    }
  }

  Future<String> getTrackId(
      String accessToken, String trackName, String artistName) async {
    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=track:$trackName%20artist:$artistName&type=track&limit=1'),
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

  Future<List<Song>> getRecommendations(
      String accessToken, String trackId) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/recommendations?seed_tracks=$trackId&limit=20'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> recommendations =
          json.decode(response.body);
      return (recommendations['tracks'] as List)
          .map((track) => Song(
                title: track['name'],
                artist: track['artists'][0]['name'],
                imageUrl: track['album']['images'][0]['url'] ?? '',
                previewUrl: track['preview_url'],
              ))
          .toList();
    } else {
      throw Exception('Failed to retrieve recommendations');
    }
  }

  void playPreview(String url) async {
    if (_currentPlayingUrl == url) {
      await _audioPlayer.stop();
      setState(() {
        _currentPlayingUrl = null;
      });
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _currentPlayingUrl = url;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
        child: FutureBuilder<List<Song>>(
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
                  final song = recommendations[index];
                  return ListTile(
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                    leading: Image.network(song.imageUrl),
                    trailing: IconButton(
                      icon: Icon(
                        _currentPlayingUrl == song.previewUrl
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                      onPressed: () async {
                        if (_currentPlayingUrl == song.previewUrl) {
                          await _audioPlayer.stop();
                          setState(() {
                            _currentPlayingUrl = null;
                          });
                        } else {
                          await _audioPlayer.play(UrlSource(song.previewUrl!)); // Use isLocal: false for remote URLs
                          setState(() {
                            _currentPlayingUrl = song.previewUrl;
                          });
                        }
                      },
                    ),
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

class Song {
  final String title;
  final String artist;
  final String imageUrl;
  final String? previewUrl;

  Song({
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.previewUrl,
  });
}
