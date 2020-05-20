import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:quizzer/components/question.dart';
import 'package:quizzer/home.dart';
import 'package:quizzer/resultpage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class getjson extends StatelessWidget {
  List mydata;
  final dbRef = FirebaseDatabase.instance.reference().child("Questions");
  final wordref = FirebaseDatabase.instance.reference().child("Words");
  List mywords;
  ListTile _buildItemsForListView(BuildContext context, int index) {
    index = 1;
    return ListTile(
      title: mywords[index]["Word"],
      subtitle:
          Text(mywords[index]["Meanings"], style: TextStyle(fontSize: 18)),
    );
  }

  int r;
  String langname;
  getjson(this.langname);
  String assettoload;
  List lists = [];
  int u;
  setasset() {
    if (langname == "Dictionary") {
      r = 1;
      //assettoload = "assets/cpp.json";
    } else if (langname == "Test") {
      r = 2;
      assettoload = "assets/test.json";
    } else if (langname == "Computer Quiz") {
      assettoload = "assets/cpp.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setasset();
    if (r == 1) {
      return MaterialApp(
        //title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
            primaryColor: Color(0xFF1D1E33),
            scaffoldBackgroundColor: Color(0xFF0A0E21),
            cardColor: Colors.teal,
            textSelectionColor: Colors.teal,
            textTheme: TextTheme(body1: TextStyle(color: Colors.teal))),
        home: MyHomePage(),
      );
    } else if (r == 2) {
      List mydata;
      // and now we return the FutureBuilder to load and decode JSON
      return FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.value[1]);
            final List<dynamic> doc = List.castFrom(snapshot.data.value);
            //print(doc);
            mydata = doc;
            int k = 4;
            print(mydata[1]["Option$k"]);
          }
          // mydata = doc;
          if (mydata == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  "Loading",
                ),
              ),
            );
          } else {
            return quizpage(mydata: mydata);
          }
        },
      );
    } else {
      List mywords;
      return FutureBuilder(
        future: wordref.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            print('aaaaa');
            print(snapshot.data.value[1]);
            //print(snapshot.data);
            //Map<dynamic, dynamic> values = snapshot.data.value;
            //   values.forEach((key, values) {
            //   lists.add(values);
            //});
            final List<dynamic> doc = List.castFrom(snapshot.data.value);
            //  final tempSections = List.castFrom(doc["Questions"]).toList();
            //print(doc);
            mywords = doc;
            int k = 4;
            //mywords[0] = mywords[8];
            print(mywords[0]);
          }
          if (mywords == null) {
            // mywords.removeAt(0);
            return Scaffold(
              body: Center(
                child: Text(
                  "Loading",
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Weekly Words'),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(48.0),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            child: Container(
                              child: Text("Click here home page"),
                            ),
                            color: Colors.teal,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return homepage();
                              }));
                            }),
                        SizedBox(
                          width: 20,
                        ),
                        FlatButton(
                            child: Container(
                              child: Text("Click here Quiz"),
                            ),
                            color: Colors.deepPurple,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                // and now we return the FutureBuilder to load and decode JSON
                                return FutureBuilder(
                                  future: dbRef.once(),
                                  builder: (context,
                                      AsyncSnapshot<DataSnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      print('aaaaa');
                                      print(snapshot.data.value[1]);
                                      //print(snapshot.data);
                                      //Map<dynamic, dynamic> values = snapshot.data.value;
                                      //   values.forEach((key, values) {
                                      //   lists.add(values);
                                      //});
                                      final List<dynamic> doc =
                                          List.castFrom(snapshot.data.value);
                                      //  final tempSections = List.castFrom(doc["Questions"]).toList();
                                      //print(doc);
                                      mydata = doc;
                                      int k = 4;
                                      print(mydata[1]["Option$k"]);
                                    }
                                    // mydata = doc;
                                    if (mydata == null) {
                                      return Scaffold(
                                        body: Center(
                                          child: Text(
                                            "Loading",
                                          ),
                                        ),
                                      );
                                    } else {
                                      return quizpage(mydata: mydata);
                                    }
                                  },
                                );
                              }));
                            }),
                      ],
                    ),
                  ),
                ),
                body: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: mywords.length,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        //color: Colors.amber[colorCodes[index]],
                        title: Text(mywords[index]["Word"]),
                        subtitle: Text(mywords[index]["Meanings"]),
                      );
                    }));
          }
        },
      );
    }
    //});
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "e64a688c68e7837fa44eea2a15d0c9f2c4213861";

  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  Timer _debounce;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(_url + _controller.text.trim(),
        headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.teal,
                    onChanged: (String text) {
                      if (_debounce?.isActive ?? false) _debounce.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        _search();
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      fillColor: Colors.teal,
                      hoverColor: Colors.teal,
                      hintText: "Search for a word",
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  _search();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => homepage(),
                  ));
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text(" Search word"),
              );
            }

            if (snapshot.data == "waiting") {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index) {
                return ListBody(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[300],
                      child: ListTile(
                        leading: snapshot.data["definitions"][index]
                                    ["image_url"] ==
                                null
                            ? null
                            : CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                    .data["definitions"][index]["image_url"]),
                              ),
                        title: Text(_controller.text.trim() +
                            "(" +
                            snapshot.data["definitions"][index]["type"] +
                            ")"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          snapshot.data["definitions"][index]["definition"]),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class quizpage extends StatefulWidget {
  List mydata;

  quizpage({Key key, @required this.mydata}) : super(key: key);
  @override
  _quizpageState createState() => _quizpageState(mydata);
}

class _quizpageState extends State<quizpage> {
  List mydata;
  _quizpageState(this.mydata);

  Color colortoshow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 1;
  // extra varibale to iterate
  int j = 1;
  int timer = 30;
  String showtimer = "30";

  Map<int, Color> btncolor = {
    1: Colors.indigoAccent,
    2: Colors.indigoAccent,
    3: Colors.indigoAccent,
    4: Colors.indigoAccent,
  };

  bool canceltimer = false;

  // code inserted for choosing questions randomly
  // to create the array elements randomly use the dart:math module
  // -----     CODE TO GENERATE ARRAY RANDOMLY

  // import 'dart:math';

  //   var random_array;
  //   var distinctIds = [];
  //   var rand = new Random();
  //     for (int i = 0; ;) {
  //     distinctIds.add(rand.nextInt(10));
  //       random_array = distinctIds.toSet().toList();
  //       if(random_array.length < 10){
  //         continue;
  //       }else{
  //         break;
  //       }
  //     }
  //   print(random_array);

  // ----- END OF CODE
  //var random_array = [1, 6, 7, 2, 4, 10, 8, 3, 9, 5];
  //var rnd;
  var min = 1;
  var max = 11;
  List<int> nu = [1];

  var rnd = new Random();
  int num() {
    if (nu.length == 10) {
      nu.clear();
      nu.add(1);
    }
    int q = 0;
    int i;
    i = min + rnd.nextInt(max - min);
    for (int j = 0; j < nu.length; j++) {
      if (i == nu[j]) {
        i = min + rnd.nextInt(max - min);
        j = 0;
      }
    }
    nu.add(i);
    // print(i);
    return i;
  }

  // overriding the initstate function to start timer as this screen is created
  @override
  void initState() {
    starttimer();
    super.initState();
  }

  // overriding the setstate function to be called only if mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 30;
    setState(() {
      if (j < 10) {
        //i = random_array[j];
        i = num();
        j++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => resultpage(marks: marks),
        ));
      }
      btncolor[1] = Colors.indigoAccent;
      btncolor[2] = Colors.indigoAccent;
      btncolor[3] = Colors.indigoAccent;
      btncolor[4] = Colors.indigoAccent;
    });
    starttimer();
  }

  void checkanswer(int k) {
    if (mydata[i]["answer"] == mydata[i]["Option$k"]) {
      marks = marks + 5;
      // changing the color variable to be green
      colortoshow = right;
    } else {
      // just a print sattement to check the correct working
      // debugPrint(mydata[2]["1"] + " is equal to " + mydata[1]["1"][k]);
      colortoshow = wrong;
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
      canceltimer = true;
    });

    // changed timer duration to 1 second
    Timer(Duration(seconds: 1), nextquestion);
  }

  Widget choicebutton(int k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: Text(
          mydata[i]["Option$k"],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    "Quizstar",
                  ),
                  content: Text("You Can't Go Back At This Stage."),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                      ),
                    )
                  ],
                ));
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  mydata[i]["Question"],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choicebutton(1),
                    choicebutton(2),
                    choicebutton(3),
                    choicebutton(4),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
