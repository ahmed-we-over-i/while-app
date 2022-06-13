import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/timer/misc/constants.dart';

class CircleBordered extends CustomPainter {
  late double offset;
  late double opacity;
  late Color color;

  CircleBordered(this.offset, this.opacity, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleBorderWidth * 2;

    canvas.drawCircle(Offset(size.width / 2, offset), circleRadius - circleBorderWidth, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
