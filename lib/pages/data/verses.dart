import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> getVerses(String book, int chapter) async {
  final String lowerCaseBook = book.toLowerCase(); // Convert book to lowercase
  final String url = 'https://bible-api.com/$lowerCaseBook%20$chapter?translation=webbe';

  try {
    final http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(res.body);
      List<String> versesList = [];
      for (var verse in data['verses']) {
        versesList.add(verse['text']);
      }
      return versesList;
    } else {
      throw Exception('Failed to load verses');
    }
  } catch (e) {
    print('Error fetching verses: $e');
    rethrow;
  }
}
