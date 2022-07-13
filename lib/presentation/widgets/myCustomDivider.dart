import 'package:flutter/material.dart';
import 'package:while_app/presentation/misc/enums.dart';

class MyCustomDivider extends StatelessWidget {
  const MyCustomDivider({Key? key, required this.mode}) : super(key: key);

  final ColorMode mode;

  @override
  Widget build(BuildContext context) {
    return Divider(color: (mode == ColorMode.light) ? Colors.grey : Colors.white60, thickness: 0.2, height: 0.2);
  }
}
