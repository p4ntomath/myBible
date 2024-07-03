// ignore_for_file: prefer_const_constructors, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import '../versesPage.dart';

class Chapterscard extends StatelessWidget {
  final int chapter;
  final String title;

  const Chapterscard ({
    super.key,
    required this.chapter,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        child: ListTile(
          trailing: Icon(Icons.arrow_forward),
          leading: Icon(Icons.menu_book_outlined),
          title: Text('Chapter ' + '$chapter'),
          tileColor: Colors.grey[400],
          onTap: () {
            Navigator.push(context,
            MaterialPageRoute(builder:
            (context)=>
            VersesScreen(book: title, chapter: chapter)));
          },
        ),
      ),
    );
  }
}
