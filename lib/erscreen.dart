import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizzer/welcome_screen.dart';

void main() => runApp(MyError());

class MyError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "QuizApp",
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF1D1E33),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: Scaffold(
          body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Invalid mail or password,please enter your mail and password"),
              OutlineButton(
                child: Text("Go to Welcome Screen"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WelcomeScreen();
                  }));
                },
              ),
            ]),
      )),
    );
  }
}
