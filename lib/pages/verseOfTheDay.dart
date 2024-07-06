// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_super_parameters

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'data/dailyverse.dart';
import 'data/images.dart';

class DailyVerse extends StatelessWidget {
  DailyVerse({Key? key}) : super(key: key);

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("For You"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[100],
      ),
      body: FutureBuilder<BibleVerse>(
        future: fetchBibleVerse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error occurred \n ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            BibleVerse verse = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Verse Of The Day",
                      style: GoogleFonts.titilliumWeb(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              getRandomImage(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                Text(
                                  verse.text,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 2.0,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  verse.reference,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 2.0,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => saveAndShare(),
                          child: Row(
                            children: [
                              Icon(Icons.share, color: Colors.black,),
                              SizedBox(width: 5),
                              Text(
                                "Share",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[100],
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }


  Future<void> saveAndShare() async {
    final Uint8List? bytes = await screenshotController.capture();
    if (bytes == null) return;
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/mybible.jpg');
    await image.writeAsBytes(bytes);
    await Share.shareFiles([image.path]);
  }

}
