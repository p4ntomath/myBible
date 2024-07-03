// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../chaptersPage.dart';

class bibleBookCard extends StatelessWidget {
  final String title;
  final int numberOfChapters;

  const bibleBookCard({
    super.key,
    required this.title,
    required this.numberOfChapters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        child: ListTile(
          trailing: Icon(Icons.arrow_forward),
          leading: Icon(Icons.menu_book_outlined),
          title: Text(title),
          subtitle: Text("$numberOfChapters Chapters"),
          tileColor: Colors.grey[400],
          onTap: () {
            Navigator.push(context,
            MaterialPageRoute(builder:
            (context)=>
            ChaptersPage(book: title, count: numberOfChapters)));
          },
        ),
      ),
    );
  }
}
