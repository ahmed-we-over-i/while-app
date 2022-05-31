import 'package:flutter/material.dart';
import 'package:while_app/presentation/constants.dart';

class Circle extends CustomPainter {
  late double offset;
  late double opacity;

  Circle(this.offset, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color.fromRGBO(100, 100, 100, opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, offset), circleRadius, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
