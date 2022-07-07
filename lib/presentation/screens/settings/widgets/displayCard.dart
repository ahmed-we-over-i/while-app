import 'package:flutter/material.dart';
import 'package:while_app/presentation/misc/colors.dart';
import 'package:while_app/presentation/misc/enums.dart';

class DisplayCard extends StatelessWidget {
  const DisplayCard({Key? key, required this.height, required this.width, required this.mode, required this.text, required this.theme, required this.cardMode}) : super(key: key);

  final double height;
  final double width;
  final ColorMode mode;
  final String text;
  final ColorTheme theme;
  final ColorMode cardMode;

  @override
  Widget build(BuildContext context) {
    final customTheme = GetColors(theme, cardMode);

    return Column(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white, width: 0.25),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                customTheme.backgroundColor,
                customTheme.backgroundColor,
                customTheme.bottomColor,
                customTheme.bottomColor,
              ],
              stops: [0, 0.5, 0.5, 1],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Text('Swipe up to start', textAlign: TextAlign.center, style: TextStyle(color: customTheme.foregroundColor)),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Text(text, style: TextStyle(height: 1.5, fontSize: 15, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
      ],
    );
  }
}
