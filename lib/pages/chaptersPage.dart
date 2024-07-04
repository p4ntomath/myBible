// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'components/chaptersCard.dart';

class ChaptersPage extends StatelessWidget {
  final String book;
  final int count;

  const ChaptersPage({
    super.key,
    required this.book,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return Chapterscard(chapter: index + 1,title: book,);
        },
      ),
    );
  }
}
