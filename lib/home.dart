import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer/quizpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizzer/welcome_screen.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final _auth = FirebaseAuth.instance;

  List<String> images = [
    "images/dic.png",
    "images/quiz.png",
    "images/Weekly.png",
  ];

  List<String> des = [
    "A dictionary is a listing of words in one or more specific languages often arranged alphabetically,which may include information on definitions, usage !!",
    "A quiz is a form of game or mind sport,in which the players attempt to answer questions correctly.It is a game to test the knowledge about a certain subject!!",
    "Ten words every week to build an exceptional vocabulary",
  ];

  Widget customcard(String langname, String image, String des) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => getjson(langname),
          ));
        },
        child: Material(
          color: Colors.red,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      // changing from 200 to 150 as to look better
                      height: 150.0,
                      width: 150.0,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            image,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    langname,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Quando",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    des,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: "Alike"),
                    maxLines: 10,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.signOutAlt),
              onPressed: () {
                _auth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WelcomeScreen();
                }));
              }),
        ],
        title: Text(
          "QuizApp",
          style: TextStyle(
            fontFamily: "Quando",
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          customcard("Dictionary", images[0], des[0]),
          customcard("Test", images[1], des[1]),
          customcard("Weekly Word", images[2], des[2]),
          //customcard("C++", images[3], des[3]),
          //customcard("Linux", images[4], des[4]),
        ],
      ),
    );
  }
}
