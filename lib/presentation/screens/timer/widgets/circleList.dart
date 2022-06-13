import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/timer/designs/circle.dart';
import 'package:while_app/presentation/screens/colors.dart';
import 'package:while_app/presentation/screens/timer/misc/constants.dart';

class CircleList extends StatelessWidget {
  const CircleList({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: (height / 2) + spaceBetweenDots + circleRadius),
        for (int i = 1; i <= maxTime; i++)
          Container(
            margin: const EdgeInsets.only(bottom: spaceBetweenDots),
            height: circleRadius * 2,
            width: double.infinity,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoadedState) {
                  CustomTheme customTheme = GetColors(state.settings.theme, state.settings.mode);

                  return CustomPaint(
                    painter: Circle(circleRadius, 1, customTheme.foregroundColor),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        SizedBox(height: height / 2),
      ],
    );
  }
}
