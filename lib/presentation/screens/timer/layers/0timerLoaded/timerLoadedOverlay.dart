import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/session/session_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/screens/timer/designs/circle.dart';
import 'package:while_app/presentation/misc/colors.dart';
import 'package:while_app/presentation/screens/timer/misc/functions.dart';
import 'package:while_app/presentation/screens/timer/misc/variables.dart';
import 'backFromPauseMinutes.dart';
import 'backFromPauseSeconds.dart';

enum OverlayType {
  firstTransition,
  backFromPause,
  normal,
}

class TimerLoadedOverlay extends StatefulWidget {
  const TimerLoadedOverlay({Key? key, required this.height, required this.scrollController, required this.blockChange}) : super(key: key);

  final double height;
  final ScrollController scrollController;
  final Function blockChange;

  @override
  State<TimerLoadedOverlay> createState() => _TimerLoadedOverlayState();
}

class _TimerLoadedOverlayState extends State<TimerLoadedOverlay> with WidgetsBindingObserver, TickerProviderStateMixin {
  late DateTime finishingTime;

  Timer? countdownTimer;

  late int countdownValue;

  late int secondsRemaining;

  final ValueNotifier<OverlayType> _overlayType = ValueNotifier(OverlayType.normal);
  late final AnimationController _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

  _onAnimationComplete() {
    if (_animationController.isCompleted) {
      if (_overlayType.value != OverlayType.backFromPause) _overlayType.value = OverlayType.normal;
      _animationController.reset();
    }
  }

  _animateOffsetToNewPosition() {
    double newOffset = calculateActualOffset(countdownValue);
    widget.blockChange.call(true);
    widget.scrollController.animateTo(newOffset, duration: const Duration(milliseconds: 200), curve: Curves.linear);
    _animationController.forward();
  }

  _checkCountdownAction({bool wasPaused = false, bool hasChanged = false}) {
    if (!wasPaused || hasChanged) _animateOffsetToNewPosition();

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
      _overlayType.value = OverlayType.firstTransition;
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

  int bfpSecondsBefore = 0;
  int? bfpMinutes = null;
  int bfpSecondsAfter = 0;

  backFromPauseRunner({required int secondsBefore, int? minutes, required int secondsAfter}) async {
    bfpSecondsBefore = secondsBefore;
    bfpMinutes = minutes;
    bfpSecondsAfter = secondsAfter;

    _overlayType.value = OverlayType.backFromPause;

    Future.delayed(Duration(seconds: 2), () {
      _overlayType.value = OverlayType.normal;
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

      final state = context.read<SettingsBloc>().state;

      if (state is SettingsLoadedState) {
        startNotification(sound: state.settings.sound, vibration: state.settings.vibration, chime: state.settings.endChime, scheduled: finishingTime);
      }
    }
    if (state == AppLifecycleState.resumed) {
      stopNotifications();

      int timeDifference = finishingTime.difference(DateTime.now()).inSeconds;

      if (timeDifference < 0) timeDifference = 0;

      final int oldSecondsRemaining = secondsRemaining;

      secondsRemaining = timeDifference % 60;

      final int newCountdownValue = (timeDifference / 60).ceil() - 1;

      context.read<SessionBloc>().add(SessionIncrementEvent(num: countdownValue - newCountdownValue));

      if (newCountdownValue != countdownValue)
        backFromPauseRunner(secondsBefore: oldSecondsRemaining, minutes: max(0, (countdownValue - newCountdownValue) - 1), secondsAfter: secondsRemaining);
      else if (secondsRemaining != oldSecondsRemaining) backFromPauseRunner(secondsBefore: oldSecondsRemaining, secondsAfter: secondsRemaining);

      bool hasChanged = (countdownValue != newCountdownValue);

      if (hasChanged) {
        countdownValue = newCountdownValue;

        _checkCountdownAction(wasPaused: true, hasChanged: true);
      } else {
        _checkCountdownAction(wasPaused: true);
      }

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
            valueListenable: _overlayType,
            builder: (context, value, child) {
              if (value == OverlayType.firstTransition) {
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
              if (value == OverlayType.backFromPause) {
                if (bfpMinutes != null)
                  return BackFromPauseMinutes(
                      secondsBefore: bfpSecondsBefore, minutes: bfpMinutes!, secondsAfter: bfpSecondsAfter, color: customTheme.foregroundColor, height: widget.height);
                else
                  return BackFromPauseSeconds(secondsBefore: bfpSecondsBefore, secondsAfter: bfpSecondsAfter, color: customTheme.foregroundColor, height: widget.height);
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
