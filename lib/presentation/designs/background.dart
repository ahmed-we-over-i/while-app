import 'package:flutter/rendering.dart';

BoxDecoration backgroundDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(210, 210, 210, 1),
        Color.fromRGBO(210, 210, 210, 1),
      ],
      stops: [0, 0.5, 0.5, 1],
    ),
  );
}
