import 'package:flutter/material.dart';
import 'face_detection_page.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final items = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home Page')),
    BottomNavigationBarItem(
        icon: Icon(Icons.music_video), title: Text('Listen')),
    BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('message'))
  ];
  // This widget is the root of your application.
  int currentIndex = 0;
  List bodyList;
  _MyHomePageState() {
    bodyList = [FaceDetectionPage(), Text("2"), Text("3")];
  }
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Testing background distance',
        home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                items: items, currentIndex: currentIndex, onTap: onTap),
            // body: bodyList[currentIndex],
            body: Stack(
              children: [
                Offstage(
                  offstage: currentIndex != 0,
                  child: bodyList[0],
                ),
                Offstage(
                  offstage: currentIndex != 1,
                  child: bodyList[1],
                ),
                Offstage(
                  offstage: currentIndex != 2,
                  child: bodyList[2],
                ),
              ],
            )));
  }
}
