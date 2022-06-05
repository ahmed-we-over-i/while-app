import 'package:flutter/material.dart';
import 'package:while_app/presentation/constants.dart';
import 'package:while_app/presentation/designs/circle.dart';

class CircleList extends StatelessWidget {
  const CircleList({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: (height / 2) + spaceBetweenDots + circleRadius),
        for (int i = 1; i <= maxTime; i++)
          Container(
            margin: const EdgeInsets.only(bottom: spaceBetweenDots),
            height: circleRadius * 2,
            width: double.infinity,
            child: CustomPaint(painter: Circle(circleRadius, 1)),
          ),
        SizedBox(height: height / 2),
      ],
    );
  }
}
