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
  List<Offset> _points = <Offset>[];
  List<Offset> _pointsSaved = <Offset>[];
  List<Offset> _pointsSaved2 = <Offset>[];
  //List<List<Offset>> _pointList= [];
  var _pointList = new List<List<Offset>>(50);
  int i = 0;
  int j = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(children: <Widget>[
        Row(
          children: <Widget>[
            new Container(
              child: new GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    RenderBox object = context.findRenderObject();
                    Offset _localPosition =
                        object.globalToLocal(details.globalPosition);
                    _points = new List.from(_points)..add(_localPosition);
                  });
                },
                onPanEnd: (DragEndDetails details) => _points.add(null),
                child: new CustomPaint(
                  painter: new Signature(points: _points),
                  size: Size.fromWidth(MediaQuery.of(context).size.width / 2),
                ),
              ),
            ),
            new Container(
              child: new GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    RenderBox object = context.findRenderObject();
                    Offset _localPosition =
                        object.globalToLocal(details.globalPosition);
                    _points = new List.from(_points)..add(_localPosition);
                  });
                },
                onPanEnd: (DragEndDetails details) {
                  setState(() {
                    _points.add(null);
                    _pointList[i] = _points;
                    i++;
                  });
                },
                child: new CustomPaint(
                  painter: new Signature(points: _points),
                  size: Size.fromWidth(MediaQuery.of(context).size.width / 2),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: RaisedButton(
            child: Text("1.save"),
            onPressed: () {
              setState(() {
                _pointList[i] = _points;
                i++;
              });
            },
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: RaisedButton(
            child: Text("1.load"),
            onPressed: () {
              setState(() {
                _points = _pointList[j];
                j++;
              });
            },
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: RaisedButton(
            child: Text("2.load"),
            onPressed: () {
              setState(() {
                //j++;
                _points = _pointsSaved2;
              });
            },
          ),
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.clear),
        onPressed: () {
          _points.clear();
        },
      ),
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
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
