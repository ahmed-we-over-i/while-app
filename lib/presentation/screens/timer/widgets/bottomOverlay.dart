import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/constants.dart';

class BottomOverlay extends StatelessWidget {
  const BottomOverlay({Key? key, required this.offset, required this.height}) : super(key: key);

  final ValueNotifier<double> offset;
  final double height;

  @override
  Widget build(BuildContext context) {
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
                    Color.fromRGBO(210, 210, 210, (state is TimerLoadingState || state is TimerLoadedState) ? 1 : 0),
                    Color.fromRGBO(210, 210, 210, (state is TimerLoadingState || state is TimerLoadedState) ? 1 : 0.85),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
