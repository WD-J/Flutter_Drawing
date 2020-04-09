import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Offset> _points = <Offset>[]; //This is the list we store the points.
  List<Offset> _pointsSaved = <Offset>[];

  List<List<Offset>> _pointList = [];

  int i = 0;
  int j = 0;
  double v = -4;
  String tool = 'pen';

//For switching between tools, 'pen' and 'eraser'.
  toolSwap(String viewName) {
    setState(() {
      tool = viewName;
    });
  }
//Changes Icon color when tool is selected.
  Color activeToolColor(String viewName) {
    if (tool == viewName) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }
  

  Widget build(BuildContext context) {
    return Scaffold(
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
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              //Adds the point you are tapping on to the '_points' list as Offset(x,y). Later we draw those points.

              if (tool == 'pen') { 
                RenderBox object = context.findRenderObject();
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                _points = List.from(_points)..add(_localPosition);
              } else if (tool == 'eraser') {
                RenderBox object = context.findRenderObject();
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                _points = List.from(_points)..remove(_localPosition);

                //This part is not working.
              }
              setState(() {});
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
        Positioned( // This button clears all drawings.
          bottom: 35,
          right: 25,
          child: Material(
            borderRadius: BorderRadius.circular(40),
            elevation: 8,
            child: SizedBox.fromSize(
              size: Size(40, 40),
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
        Positioned( //This button switches tool to eraser.
          bottom: 35,
          right: 75,
          child: Material(
            borderRadius: BorderRadius.circular(40),
            elevation: 8,
            child: SizedBox.fromSize(
              size: Size(40, 40),
              child: ClipOval(
                child: Material(
                  color: Colors.amber,
                  elevation: 8,
                  child: InkWell(
                    splashColor: Colors.white70,
                    onTap: () {
                      tool = 'eraser';
                      toolSwap('eraser');
                    },
                    child: IconTheme(
                      child: Icon(
                        Icons.remove_circle_outline,
                      ),
                      data: IconThemeData(color: activeToolColor('eraser')),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned( // This button switches tool the 'pen'.
          bottom: 35,
          right: 125,
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
                      tool = 'pen';
                      toolSwap('pen');
                    },
                    child: IconTheme(
                      child: Icon(
                        Icons.brush,
                      ),
                      data: IconThemeData(color: activeToolColor('pen')),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class Signature extends CustomPainter { // This is the CustomPainter which is needed for CustomPaint. We describe painting properties inside the 'Paint' in it.
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.0;

    //This loop draws all points as lines which gives us the drawing.
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
