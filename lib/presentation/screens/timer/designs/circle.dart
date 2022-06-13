import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/timer/misc/constants.dart';

class Circle extends CustomPainter {
  late double offset;
  late double opacity;
  late Color color;

  Circle(this.offset, this.opacity, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, offset), circleRadius, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
