import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/screens/colors.dart';
import 'package:while_app/presentation/screens/timer/misc/constants.dart';

class BottomOverlay extends StatelessWidget {
  const BottomOverlay({Key? key, required this.offset, required this.height}) : super(key: key);

  final ValueNotifier<double> offset;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          CustomTheme customTheme = GetColors(state.settings.theme, state.settings.mode);

          return BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              return ValueListenableBuilder(
                valueListenable: offset,
                builder: (BuildContext context, double value, Widget? child) {
                  return Container(
                    margin: EdgeInsets.only(top: value + height / 2 + circleRadius),
                    width: double.infinity,
                    height: height / 2 - circleRadius,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          customTheme.bottomColor.withOpacity((state is TimerLoadingState || state is TimerLoadedState) ? 1 : 0),
                          customTheme.bottomColor.withOpacity((state is TimerLoadingState || state is TimerLoadedState) ? 1 : 0.9),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
