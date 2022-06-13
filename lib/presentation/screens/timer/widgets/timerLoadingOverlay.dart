import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/screens/timer/designs/circleBordered.dart';
import 'package:while_app/presentation/screens/colors.dart';

class TimerLoadingOverlay extends StatefulWidget {
  const TimerLoadingOverlay({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  State<TimerLoadingOverlay> createState() => _TimerLoadingOverlayState();
}

class _TimerLoadingOverlayState extends State<TimerLoadingOverlay> {
  Timer? countdownTimer;

  int seconds = 5;

  ValueNotifier textActive = ValueNotifier(true);

  Timer? changeOpacity;

  _showTime() {
    textActive.value = true;
    changeOpacity?.cancel();
    changeOpacity = Timer.periodic(const Duration(seconds: 1), (timer) {
      textActive.value = false;
    });
  }

  Timer _startCountdownTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 1) {
        setState(() {
          seconds--;
        });
      } else {
        final value = context.read<TimerBloc>().state.value;
        context.read<TimerBloc>().add(TimerLoadedEvent(value));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showTime();
    countdownTimer = _startCountdownTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    changeOpacity?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _showTime(),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadedState) {
              CustomTheme customTheme = GetColors(state.settings.theme, state.settings.mode);

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(left: 50, bottom: 50 + widget.height / 2),
                      child: ValueListenableBuilder(
                        valueListenable: textActive,
                        builder: (context, _, __) {
                          return AnimatedOpacity(
                            opacity: textActive.value ? 1 : 0,
                            duration: const Duration(milliseconds: 500),
                            child: Text('$seconds sec', style: TextStyle(fontSize: 22, color: customTheme.foregroundColor), textAlign: TextAlign.left),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: CircleBordered(-1 * (seconds * widget.height / 120), 1, customTheme.foregroundColor),
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
