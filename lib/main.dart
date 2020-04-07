import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';


void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> _points = <Offset>[];
  List<Offset> _pointsSaved = <Offset>[];

  List<List<Offset>> _pointList = [];

  int i = 0;
  int j = 0;
  String tool = 'Pen';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/exercises/exercise_sample.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        
        Container(
          child: new GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox object = context.findRenderObject();
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                _points = new List.from(_points)..add(_localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                _points.add(null);
              });
            },
            child: new CustomPaint(
              painter: new Signature(points: _points),
              size: Size.fromWidth(MediaQuery.of(context).size.width),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: RaisedButton(
            child: Text("Save"),
            onPressed: () {
              setState(() {
                _pointsSaved.clear();
                _pointsSaved.addAll(_points);
              });
            },
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: RaisedButton(
            child: Text("Load"),
            onPressed: () {
              setState(() {
                //_points.addAll(_pointsSaved);
                _points=[Offset(161.5, 419.4), Offset(161.9, 419.4), null];
                print(_points);
              });
            },
          ),
        ),
        Positioned(
          bottom: 25,
          right: 25,
          child: Material(
            borderRadius: BorderRadius.circular(40),
            elevation: 8,
            child: SizedBox.fromSize(
              size: Size(40, 40), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.amber,
                  elevation: 8,
                  child: InkWell(
                    splashColor: Colors.white70,
                    onTap: () {
                      _points.clear();
                    },
                    child: IconTheme(
                      child: Icon(
                        Icons.sync,
                      ),
                      data: IconThemeData(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
      /*floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.clear),
        onPressed: () {
          _points.clear();
        },
      ),*/
    );
  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}

final SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.amber);



//[Offset(161.5, 419.4), Offset(161.9, 419.4), null]