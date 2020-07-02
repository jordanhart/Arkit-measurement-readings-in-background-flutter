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
            body: Stack(
              children: [
                Opacity(
                  opacity: currentIndex == 1 ? 1.0 : 0.0,
                  child: bodyList[1],
                ),
                Opacity(
                  opacity: currentIndex == 0 ? 1.0 : 0.01,//Notice how this is not 0. A 0 opacity leaves ARkit not running in the background
                  child: bodyList[0],
                ),
                RaisedButton(
                    onPressed: () {
                      onTap(1-currentIndex);// Navigate back to first route when tapped.
                    },
                    child: Text('Go back!'),
                ),
              ],
            )));
  }
}
