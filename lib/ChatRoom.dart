import 'package:cinematalks/Moviedetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'movies.dart';

class Room extends StatelessWidget {
  const Room({Key? key}) : super(key: key);
  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Image.asset(
                      'lib/film.png',
                      height: 40,
                      width: 50,
                    ),
                  ),
                  const Text(
                    'CINEMA TALKS',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 3.0),
                          blurRadius: 3.0,
                          color: Colors.grey,
                        ),
                      ],
                      fontFamily: 'KanitBlack',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          elevation: 60,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff42A974),
                  Color(0xff38A39B),
                  Color(0xff299BD4),
                ],
              ),
            ),
          ),
          //shadowColor: Colors.white,
        ),
        body: Container(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff42A974),
                  Color(0xff38A39B),
                  Color(0xff299BD4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
