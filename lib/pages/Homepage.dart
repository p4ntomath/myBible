// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unused_import

import 'package:bible/pages/Biblepage.dart';
import 'package:bible/pages/verseOfTheDay.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'musicHomePage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  int index = 0;
List<Widget> widgets = [
BiblePage(),
MusicHomePage(),
DailyVerse()
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[400],
      body: IndexedStack(
        children: widgets,
        index: index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => {
          setState(() {
            index = value;
          })
        },
        currentIndex: index,
        selectedItemColor: Colors.blue,
        items: [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.bookBible),
          label: 'Bible'),
          BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.music),
          label: 'Music'),
          BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.handshakeAngle),
          label: 'For You'),
      ],),
    );
  }
}