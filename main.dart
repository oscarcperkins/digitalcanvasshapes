import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  GlobalKey _paintKey = new GlobalKey();
  Offset _startPosition;
  Offset _shapeSize;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Drawing Circles'),
      ),
      body: new Listener(
        onPointerDown: (PointerDownEvent mouseDown) {
          RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
          Offset startPosition = referenceBox.globalToLocal(mouseDown.position);
          setState(() {
            _startPosition = startPosition;
          });
        },
        onPointerUp: (PointerUpEvent mouseUp) {
          RenderBox referenceBox = _paintKey.currentContext.findRenderObject();
          Offset shapeSize = referenceBox.globalToLocal(mouseUp.position);
          setState(() {
            _shapeSize = shapeSize;
          });
        },
        child: new CustomPaint(
          key: _paintKey,
          painter: new MyCustomPainter(_startPosition, _shapeSize),
          child: new ConstrainedBox(
            constraints: new BoxConstraints.expand(),
          ),
        ),
      ),
    );
  }

}

class MyCustomPainter extends CustomPainter {
  final Offset _startPosition;
  final Offset _shapeSize;
  MyCustomPainter(this._startPosition, this._shapeSize);

  @override
  void paint(Canvas canvas, Size size) {

    if (_startPosition == null || _shapeSize == null) return;

    double startPosX = _startPosition.dx;
    double startPosY = _startPosition.dy;
    double endPosX = _shapeSize.dx;
    double endPosY = _shapeSize.dy;
    double circleRadius = (sqrt(pow((startPosX - endPosX), 2) + pow((startPosY - endPosY), 2)))/2;

    canvas.drawCircle(_startPosition, circleRadius, new Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(MyCustomPainter other) => other._startPosition != _startPosition;
}