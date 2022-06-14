import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/enums.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key, required this.mode}) : super(key: key);

  final ColorMode mode;

  @override
  Widget build(BuildContext context) {
    return Divider(color: (mode == ColorMode.light) ? Colors.grey : Colors.white60, thickness: 0.2, height: 0.2);
  }
}
