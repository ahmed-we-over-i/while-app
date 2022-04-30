import 'package:flutter/material.dart';
import 'package:while_app/presentation/designs/circle.dart';

class CircleList extends StatelessWidget {
  const CircleList({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50 + height / 2),
        for (int i = 1; i <= 90; i++)
          Container(
            margin: const EdgeInsets.all(8),
            height: 16,
            width: double.infinity,
            child: CustomPaint(painter: Circle(0, 1)),
          ),
        SizedBox(height: height / 2),
      ],
    );
  }
}
