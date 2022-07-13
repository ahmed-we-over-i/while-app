import 'dart:math';

import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/timer/designs/circle.dart';
import 'package:while_app/presentation/screens/timer/misc/constants.dart';

class BackFromPauseSeconds extends StatefulWidget {
  const BackFromPauseSeconds({Key? key, required this.secondsBefore, required this.secondsAfter, required this.color, required this.height}) : super(key: key);

  final int secondsBefore;
  final int secondsAfter;
  final Color color;
  final double height;

  @override
  State<BackFromPauseSeconds> createState() => _BackFromPauseSecondsState();
}

class _BackFromPauseSecondsState extends State<BackFromPauseSeconds> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

  final double inBetweenVal = (circleRadius * 2) + spaceBetweenDots;

  late final Animation<double> _animation0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final int secondsBefore = widget.secondsBefore;
    final int secondsAfter = widget.secondsAfter;

    if (secondsBefore > 0) {
      final double start = secondsBefore / 60;
      final double end = (secondsAfter == 0) ? 0 : secondsAfter / 60;

      _animation0 = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: start * ((widget.height / 2) - inBetweenVal),
              end: end * ((widget.height / 2) - inBetweenVal),
            ).chain(CurveTween(curve: Curves.ease)),
            weight: (start - end) * 100,
          ),
        ],
      ).animate(_animationController);
    }

    _animationController..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: Circle(
            -1 * _animation0.value,
            max(_animation0.value / (widget.height / 2), 1 / 6),
            widget.color,
          ),
        );
      },
    );
  }
}
