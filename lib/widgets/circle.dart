import 'package:flutter/material.dart';

@immutable
class Circle extends StatelessWidget {

  final Color color;
  final double radius;

  const Circle({@required this.color, @required this.radius});

  @override
  Widget build(BuildContext context)
    => CustomPaint(painter: _CirclePainter(color: color, radius: radius));
}

@immutable
class _CirclePainter extends CustomPainter {

  final Color color;
  final double radius;
  final Paint _paint;

  _CirclePainter({@required this.color, @required this.radius})
    : _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset.zero, radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
