import 'dart:convert';
import 'package:http/http.dart' as http;


Future<BibleVerse> fetchBibleVerse() async {
    final response = await http.get(Uri.parse('https://beta.ourmanna.com/api/v1/get?format=json&order=daily'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final verseDetails = jsonResponse['verse']['details'];
      return BibleVerse(
        text: verseDetails['text'],
        reference: verseDetails['reference'],
      );
    } else {
      throw Exception('Failed to load verse');
    }
  }

  class BibleVerse {
  final String text;
  final String reference;

  BibleVerse({
    required this.text,
    required this.reference,
  });
}