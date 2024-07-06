// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String clientId = 'bd52ae0dda914329b1a8c088f8b15a41';
  final String clientSecret = 'e89e20bec02a4e898ff44cf523345580';

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<String?> fetchPreviewUrl(String trackName, String artistName) async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$trackName%20$artistName&type=track&limit=1'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['tracks']['items'];
      if (tracks.isNotEmpty) {
        return tracks[0]['preview_url'];
      } else {
        print('No tracks found');
        return null;
      }
    } else {
      throw Exception('Failed to fetch track preview URL');
    }
  }
}
