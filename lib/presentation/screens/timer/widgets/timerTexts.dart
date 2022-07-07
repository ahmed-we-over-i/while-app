import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/misc/colors.dart';

class TimerTexts extends StatefulWidget {
  TimerTexts({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  State<TimerTexts> createState() => _TimerTextsState();
}

class _TimerTextsState extends State<TimerTexts> {
  Timer? changeOpacity;

  ValueNotifier textActive = ValueNotifier(true);

  _showTime() {
    textActive.value = true;
    changeOpacity?.cancel();
    changeOpacity = Timer.periodic(const Duration(seconds: 1), (timer) {
      textActive.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _showTime.call(),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadedState) {
              CustomTheme customTheme = GetColors(state.settings.theme, state.settings.mode);

              return BlocConsumer<TimerBloc, TimerState>(
                listener: (context, state) {
                  if (state is TimerLoadedState) {
                    _showTime.call();
                  }
                },
                listenWhen: (previous, current) => ((previous is! TimerLoadedState) && (current is TimerLoadedState)),
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(left: 50, top: widget.height / 2 - 150, right: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: (state is TimerInitialState || state is TimerFinishedState) ? 1 : 0,
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Text(
                                (state is TimerFinishedState) ? 'end of session' : 'swipe up to start',
                                style: TextStyle(fontSize: 30, color: customTheme.foregroundColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        if (state is! TimerLoadingState)
                          ValueListenableBuilder(
                            valueListenable: textActive,
                            builder: (context, _, __) {
                              return AnimatedOpacity(
                                opacity: (state is TimerPickedState || state is TimerLoadedChangeState)
                                    ? 1
                                    : (state is TimerLoadedState)
                                        ? (textActive.value ? 1 : 0)
                                        : 0,
                                duration: const Duration(milliseconds: 500),
                                child: Text(state.value.toString() + ' m', style: TextStyle(fontSize: 22, color: customTheme.foregroundColor)),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
