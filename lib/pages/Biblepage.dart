// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'components/bibleBooks.dart';
import 'data/books.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bible"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bibleBooks.keys
                  .where((title) =>
                      title.toLowerCase().contains(searchQuery.toLowerCase()))
                  .length,
              itemBuilder: (context, index) {
                String title = bibleBooks.keys
                    .where((title) =>
                        title.toLowerCase().contains(searchQuery.toLowerCase()))
                    .elementAt(index);
                int chapters = bibleBooks[title]!;
                return bibleBookCard(title: title, numberOfChapters: chapters);
              },
            ),
          ),
        ],
      ),
    );
  }
}