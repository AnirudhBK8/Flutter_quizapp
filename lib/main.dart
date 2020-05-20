import 'package:flutter/material.dart';
import 'package:quizzer/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QuizApp",
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF1D1E33),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: splashscreen(),
    );
  }
}
