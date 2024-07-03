// ignore_for_file: deprecated_member_use, prefer_const_constructors, use_super_parameters, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import url_launcher package
import '../data/songs.dart'; // Adjust the import path as per your project structure

class SongCard extends StatelessWidget {
  final Track track;

  // Constructor corrected to remove unnecessary super.key
  const SongCard({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  track.albumImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              track.trackName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            track.artistName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.spotify, size: 30, color: Colors.green),
              SizedBox(width: 20),
              Icon(FontAwesomeIcons.youtube, size: 30, color: Colors.red),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  // Async function to open Spotify link


}
