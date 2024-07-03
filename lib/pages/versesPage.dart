// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'data/verses.dart';


class VersesScreen extends StatefulWidget {
  final String book;
  final int chapter;

  VersesScreen({required this.book, required this.chapter});

  @override
  _VersesScreenState createState() => _VersesScreenState();
}

class _VersesScreenState extends State<VersesScreen> {
  late Future<List<String>> _verses;

  @override
  void initState() {
    super.initState();
    _verses = getVerses(widget.book,widget.chapter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book}  ${widget.chapter}'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: FutureBuilder<List<String>>(
        future: _verses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Results'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                int verses = index+1;
                final verse = snapshot.data![index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical:0),
                  child: ListTile(
                    leading: Text('$verses'),
                    title: Text(verse),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}