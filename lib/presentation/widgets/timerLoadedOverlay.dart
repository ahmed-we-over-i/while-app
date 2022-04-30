import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/constants.dart';
import 'package:while_app/presentation/designs/circle.dart';

class TimerLoadedOverlay extends StatefulWidget {
  const TimerLoadedOverlay({Key? key, required this.height, required this.scrollController, required this.blockChange}) : super(key: key);

  final double height;
  final ScrollController scrollController;
  final VoidCallback blockChange;

  @override
  State<TimerLoadedOverlay> createState() => _TimerLoadedOverlayState();
}

class _TimerLoadedOverlayState extends State<TimerLoadedOverlay> with WidgetsBindingObserver {
  late DateTime finishingTime;

  Timer? countdownTimer;

  late int countdownValue;

  late int secondsRemaining;

  _animateOffsetToNewPosition() {
    double newOffset = (50 - circleRadius * 2) + (4 * circleRadius) * (countdownValue - 1);
    if (newOffset <= 50) newOffset = 0;
    widget.blockChange.call();
    widget.scrollController.animateTo(newOffset, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  _checkCountdownAction() {
    _animateOffsetToNewPosition();

    if (countdownValue == 0) {
      countdownTimer?.cancel();
      context.read<TimerBloc>().add(const TimerFinishedEvent());
    } else {
      context.read<TimerBloc>().add(TimerLoadedEvent(countdownValue));
    }
  }

  _restartTimer() {
    setState(() {
      secondsRemaining = 10;
    });

    _checkCountdownAction();

    countdownValue--;
  }

  Timer _startCountdownTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        _restartTimer();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    countdownValue = context.read<TimerBloc>().state.value;
    finishingTime = DateTime.now().add(Duration(seconds: 10 * countdownValue));
    _restartTimer();
    countdownTimer?.cancel();
    countdownTimer = _startCountdownTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      countdownTimer?.cancel();
    }
    if (state == AppLifecycleState.resumed) {
      int timeDifference = finishingTime.difference(DateTime.now()).inSeconds;

      secondsRemaining = timeDifference % 10;
      countdownValue = (timeDifference / 10).ceil();

      _checkCountdownAction();
      countdownTimer?.cancel();
      countdownTimer = _startCountdownTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: Circle(-1 * (secondsRemaining * widget.height / 60), 1),
      ),
    );
  }
}
