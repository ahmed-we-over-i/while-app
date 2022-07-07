import 'dart:math';

import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/timer/designs/circle.dart';
import 'package:while_app/presentation/screens/timer/misc/constants.dart';

class BackFromPause extends StatefulWidget {
  const BackFromPause({Key? key, required this.minutes, required this.seconds, required this.color, required this.height}) : super(key: key);

  final int minutes;
  final int seconds;
  final Color color;
  final double height;

  @override
  State<BackFromPause> createState() => _BackFromPauseState();
}

class _BackFromPauseState extends State<BackFromPause> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

  final double inBetweenVal = (circleRadius * 2) + spaceBetweenDots;

  late final Animation<double> _animation1;
  late final Animation<double> _animation2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animation1 = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: (widget.height / 2) - (0 * inBetweenVal * (widget.minutes + (widget.seconds == 0 ? 0 : 1))),
            end: (widget.height / 2) - (1 * inBetweenVal * (widget.minutes + (widget.seconds == 0 ? 0 : 1))),
          ).chain(CurveTween(curve: Curves.linear)),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>((widget.height / 2) - (1 * inBetweenVal * (widget.minutes + (widget.seconds == 0 ? 0 : 1)))),
          weight: 20,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: (widget.height / 2) - (inBetweenVal * (widget.minutes + (widget.seconds == 0 ? 0 : 1))),
            end: (-1 * (widget.minutes - 1) * inBetweenVal),
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 60,
        ),
      ],
    ).animate(_animationController);

    final int seconds = widget.seconds;

    if (seconds > 0) {
      final double end = seconds / 60;

      _animation2 = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: (widget.height / 2) - (0 * inBetweenVal * (widget.minutes + 1)),
              end: (widget.height / 2) - (1 * inBetweenVal * (widget.minutes + 1)),
            ).chain(CurveTween(curve: Curves.linear)),
            weight: 10,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>((widget.height / 2) - (1 * inBetweenVal * (widget.minutes + 1))),
            weight: 20,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: (1 * ((widget.height / 2) - inBetweenVal)) - (widget.minutes * inBetweenVal),
              end: (end * ((widget.height / 2) - inBetweenVal)) - (widget.minutes * inBetweenVal),
            ).chain(CurveTween(curve: Curves.ease)),
            weight: 60 * (1 - end),
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>((end * ((widget.height / 2) - inBetweenVal)) - (widget.minutes * inBetweenVal)),
            weight: 60 * end,
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i <= widget.minutes; i++)
              if (i == widget.minutes)
                if (widget.seconds > 0)
                  CustomPaint(
                    painter: Circle(
                      -1 * (_animation2.value + (i * inBetweenVal)),
                      max(max(1 - _animationController.value, widget.seconds / 60), 10 / 60),
                      widget.color,
                    ),
                  )
                else
                  SizedBox.shrink()
              else
                CustomPaint(painter: Circle(-1 * ((_animation1.value) + (i * inBetweenVal)), 1, widget.color))
          ],
        );
      },
    );
  }
}
