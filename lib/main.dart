import 'package:clobber/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clobber',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // for manage scroll of screen
  bool upDirection = true, flag = true, _extendFab = true;
  ScrollController _scrollController;

  // BuildContext for creating snakbar
  BuildContext scaffoldContext;

  //text controller for text fields
  final rowTextController = TextEditingController();
  final columnTextController = TextEditingController();

  bool isStarterBlack = false;
  bool isPlayerBlack = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rowTextController.text = '5';
    columnTextController.text = '6';
    // to extend floating action button after scrolling down
    _scrollController = ScrollController()
      ..addListener(() {
        upDirection = _scrollController.position.userScrollDirection ==
            ScrollDirection.forward;

        // makes sure we don't call setState too much, but only when it is needed
        if (upDirection != flag)
          setState(() {
            _extendFab = !_extendFab;
          });

        flag = upDirection;
      });
  }

  @override
  void dispose() {
    super.dispose();
    rowTextController.dispose();
    columnTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Clobber',
            style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 24.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: new Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return SingleChildScrollView(
            // make page scrollable
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  ': ابعاد صفحه بازی',
                  style: TextStyle(fontFamily: 'Homa', fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: TextField(
                        // text field for number of columns
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "سطر"),
                        maxLines: 1,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: false),
                        controller: columnTextController,
                      ),
                    ),
                    Text(' X '),
                    Container(
                      width: 60,
                      height: 60,
                      child: TextField(
                        // text field for number of rows
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "ستون"),
                        maxLines: 1,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: false),
                        controller: rowTextController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  ': مهره شما',
                  style: TextStyle(fontFamily: 'Homa', fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          isPlayerBlack = false;
                        });
                      },
                      color: isPlayerBlack ? Colors.white : Colors.blue[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue[800])),
                      child: Text(
                        'سفید',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Homa',
                            fontSize: 18,
                            color: isPlayerBlack
                                ? Colors.blue[900]
                                : Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          isPlayerBlack = true;
                        });
                      },
                      color: isPlayerBlack ? Colors.blue[800] : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue[800])),
                      child: Text(
                        'سیاه',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Homa',
                            fontSize: 18,
                            color: isPlayerBlack
                                ? Colors.white
                                : Colors.blue[900]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  ': شروع کننده بازی',
                  style: TextStyle(fontFamily: 'Homa', fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          isStarterBlack = false;
                        });
                      },
                      color: isStarterBlack ? Colors.white : Colors.blue[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue[800])),
                      child: Text(
                        'سفید',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Homa',
                            fontSize: 18,
                            color: isStarterBlack
                                ? Colors.blue[900]
                                : Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          isStarterBlack = true;
                        });
                      },
                      color: isStarterBlack ? Colors.blue[800] : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue[800])),
                      child: Text(
                        'سیاه',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Homa',
                            fontSize: 18,
                            color: isStarterBlack
                                ? Colors.white
                                : Colors.blue[900]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          );
        }),
        floatingActionButton: _extendFab // fab
            ? FloatingActionButton.extended(
                onPressed: startGame(),
                backgroundColor: Colors.red[700],
                label: Text("شروع بازی",
                    style: TextStyle(
                        fontSize: 14, fontFamily: "Homa", color: Colors.white)),
                icon: Icon(Icons.play_arrow_rounded))
            : FloatingActionButton(
                onPressed: startGame(),
                backgroundColor: Colors.red[700],
                child: Icon(Icons.play_arrow_rounded)));
  }

  Function startGame() {
    return () {
      if (rowTextController.text.isEmpty ||
          rowTextController.text.contains('.') ||
          int.parse(rowTextController.text) < 2)
        createSnackBar('.تعداد سطر ها نامعتبر است');
      else if (columnTextController.text.isEmpty ||
          columnTextController.text.contains('.') ||
          int.parse(columnTextController.text) < 2)
        createSnackBar('.تعداد ستون ها نامعتبر است');
      else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GamePage(
                  rows: int.parse(rowTextController.text),
                  cols: int.parse(columnTextController.text),
                  player: isPlayerBlack,
                  starter: isStarterBlack,
                )));
      }
    };
  }

  void createSnackBar(String message) {
    final snackBar = new SnackBar(
        content: new Text(
      message,
      style: TextStyle(fontFamily: 'Homa'),
    ));
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }
}
