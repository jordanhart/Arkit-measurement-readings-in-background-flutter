import 'package:flutter/material.dart';
import 'face_detection_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState.maybePop(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _insertOverlay(context));
            return Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/page2':
                    return MaterialPageRoute(builder: (_) => Page2());
                  default:
                    return MaterialPageRoute(
                        builder: (_) => Page1(_navigatorKey));
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _insertOverlay(BuildContext context) {
    return Overlay.of(context).insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        print(size.width);
        return Positioned(
          width: 56,
          height: 56,
          top: size.height - 72,
          left: size.width - 72,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => print('ON TAP OVERLAY!'),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.redAccent),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class Page1 extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  Page1(this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(title: Text('Page1')),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: [
          FaceDetectionPage(),
          RaisedButton(
            child: Text('go to Page2'),
            onPressed: () => navigatorKey.currentState.pushNamed('/page2'),
          )
        ]),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(title: Text('back to Page1')),
      body: Container(
        alignment: Alignment.center,
        child: Text('Page 2'),
      ),
    );
  }
}
