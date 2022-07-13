import 'dart:math';

import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/timer/designs/circle.dart';
import 'package:while_app/presentation/screens/timer/misc/constants.dart';

class BackFromPauseMinutes extends StatefulWidget {
  const BackFromPauseMinutes({
    Key? key,
    required this.secondsBefore,
    required this.minutes,
    required this.secondsAfter,
    required this.color,
    required this.height,
  }) : super(key: key);

  final int secondsBefore;
  final int minutes;
  final int secondsAfter;
  final Color color;
  final double height;

  @override
  State<BackFromPauseMinutes> createState() => _BackFromPauseMinutesState();
}

class _BackFromPauseMinutesState extends State<BackFromPauseMinutes> with TickerProviderStateMixin {
  late final AnimationController _animationController0 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  late final AnimationController _animationController1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

  final double inBetweenVal = (circleRadius * 2) + spaceBetweenDots;

  late final Animation<double> _animation0;
  late final Animation<double> _animation1;
  late final Animation<double> _animation2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final int secondsBefore = widget.secondsBefore;

    if (secondsBefore > 0) {
      final double start = secondsBefore / 60;

      _animation0 = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: start * ((widget.height / 2) - inBetweenVal),
              end: 0 * ((widget.height / 2) - inBetweenVal),
            ).chain(CurveTween(curve: Curves.ease)),
            weight: start * 100,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(0 * ((widget.height / 2) - inBetweenVal)),
            weight: (1 - start) * 100,
          ),
        ],
      ).animate(_animationController0);
    }

    _animation1 = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: (widget.height / 2) - (0 * inBetweenVal * (widget.minutes + (widget.secondsAfter == 0 ? 0 : 1))),
            end: (widget.height / 2) - (1 * inBetweenVal * (widget.minutes + (widget.secondsAfter == 0 ? 0 : 1))),
          ).chain(CurveTween(curve: Curves.linear)),
          weight: 10,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>((widget.height / 2) - (1 * inBetweenVal * (widget.minutes + (widget.secondsAfter == 0 ? 0 : 1)))),
          weight: 20,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: (widget.height / 2) - (inBetweenVal * (widget.minutes + (widget.secondsAfter == 0 ? 0 : 1))),
            end: (-1 * (widget.minutes - 1) * inBetweenVal),
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 60,
        ),
      ],
    ).animate(_animationController1);

    final int seconds = widget.secondsAfter;

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
      ).animate(_animationController1);
    }

    _animationController0..forward();
    _animationController1..forward();
  }

  @override
  void dispose() {
    _animationController0.dispose();
    _animationController1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animationController0,
          builder: (context, child) {
            if (widget.secondsBefore > 0)
              return CustomPaint(
                painter: Circle(
                  -1 * _animation0.value,
                  _animation0.value / (widget.height / 2),
                  widget.color,
                ),
              );
            return SizedBox.shrink();
          },
        ),
        AnimatedBuilder(
          animation: _animationController1,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i <= widget.minutes; i++)
                  if (i == widget.minutes)
                    if (widget.secondsAfter > 0)
                      CustomPaint(
                        painter: Circle(
                          -1 * (_animation2.value + (i * inBetweenVal)),
                          max(_animation2.value / (widget.height / 2), 1 / 6),
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
        ),
      ],
    );
  }
}
