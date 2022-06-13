import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/session/session_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/screens/timer/designs/circle.dart';
import 'package:while_app/presentation/screens/colors.dart';
import 'package:while_app/presentation/screens/timer/misc/variables.dart';

class TimerLoadedOverlay extends StatefulWidget {
  const TimerLoadedOverlay({Key? key, required this.height, required this.scrollController, required this.blockChange}) : super(key: key);

  final double height;
  final ScrollController scrollController;
  final VoidCallback blockChange;

  @override
  State<TimerLoadedOverlay> createState() => _TimerLoadedOverlayState();
}

class _TimerLoadedOverlayState extends State<TimerLoadedOverlay> with WidgetsBindingObserver, TickerProviderStateMixin {
  late DateTime finishingTime;

  Timer? countdownTimer;

  late int countdownValue;

  late int secondsRemaining;

  final ValueNotifier _firstTransition = ValueNotifier(true);
  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

  _onAnimationComplete() {
    if (_animationController.isCompleted) {
      _firstTransition.value = true;
      _animationController.reset();
    }
  }

  _animateOffsetToNewPosition() {
    double newOffset = calculateActualOffset(countdownValue);
    widget.blockChange.call();
    widget.scrollController.animateTo(newOffset, duration: const Duration(milliseconds: 200), curve: Curves.linear);
    _animationController.forward();
  }

  _checkCountdownAction({bool wasPaused = false}) {
    _animateOffsetToNewPosition();

    if (countdownValue < 0) {
      countdownTimer?.cancel();
      context.read<TimerBloc>().add(TimerFinishedEvent(soundVibration: !wasPaused));
    } else {
      context.read<TimerBloc>().add(TimerLoadedEvent(countdownValue + 1));
    }
  }

  _restartTimer() {
    setState(() {
      secondsRemaining = 60;
      _firstTransition.value = false;
    });

    countdownValue--;

    _checkCountdownAction();
  }

  Timer _startCountdownTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        context.read<SessionBloc>().add(SessionIncrementEvent());
        _restartTimer();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.addListener(_onAnimationComplete);
    countdownValue = context.read<TimerBloc>().state.value;
    final Duration _duration = Duration(seconds: 60 * countdownValue);
    finishingTime = DateTime.now().add(_duration);

    _restartTimer();
    countdownTimer?.cancel();
    countdownTimer = _startCountdownTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      countdownTimer?.cancel();

      final Duration _duration = finishingTime.difference(DateTime.now());
    }
    if (state == AppLifecycleState.resumed) {
      int timeDifference = finishingTime.difference(DateTime.now()).inSeconds;

      secondsRemaining = timeDifference % 60;

      final int newCountdownValue = (timeDifference / 60).ceil() - 1;

      context.read<SessionBloc>().add(SessionIncrementEvent(num: countdownValue - newCountdownValue));

      countdownValue = newCountdownValue;

      _checkCountdownAction(wasPaused: true);
      countdownTimer?.cancel();
      countdownTimer = _startCountdownTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    countdownTimer?.cancel();
    _animationController.removeListener(_onAnimationComplete);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          CustomTheme customTheme = GetColors(state.settings.theme, state.settings.mode);

          return ValueListenableBuilder(
            valueListenable: _firstTransition,
            builder: (context, value, child) {
              if (value == false) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: CustomPaint(painter: Circle(calculateCircleDrop(widget.height, _animationController.value), 1, customTheme.foregroundColor)),
                    );
                  },
                );
              }
              return SizedBox(
                width: double.infinity,
                child: CustomPaint(
                  painter: Circle(
                    calculateLoadedCirclePosition(widget.height, secondsRemaining),
                    secondsRemaining < 10 ? (10 / 60) : secondsRemaining / 60,
                    customTheme.foregroundColor,
                  ),
                ),
              );
            },
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
