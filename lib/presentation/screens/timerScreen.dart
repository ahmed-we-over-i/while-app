import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/constants.dart';
import 'package:while_app/presentation/designs/background.dart';
import 'package:while_app/presentation/enums.dart';
import 'package:while_app/presentation/widgets/bottomOverlay.dart';
import 'package:while_app/presentation/widgets/circleList.dart';
import 'package:while_app/presentation/widgets/floatingButton.dart';
import 'package:while_app/presentation/widgets/timerLoadedOverlay.dart';
import 'package:while_app/presentation/widgets/timerLoadingOverlay.dart';
import 'package:while_app/presentation/widgets/timerTexts.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final ScrollController _scrollController = ScrollController();

  late double height;
  late double width;

  int circlesAboveLine = 0;

  ValueNotifier<double> offset = ValueNotifier(0);
  Timer? _shouldAdjustPosition;

  ValueNotifier<MenuValue> menuValue = ValueNotifier(MenuValue.closed);

  bool changeBlocked = false;

  void blockChange() {
    changeBlocked = true;
  }

  void _positionAdjust() {
    if (!_scrollController.position.isScrollingNotifier.value) {
      changeBlocked = false;

      int temp = ((_scrollController.offset) / ((2 * circleRadius) + spaceBetweenDots)).floor();
      if (temp > maxTime) temp = maxTime;
      double actualOffset = (((2 * circleRadius) + spaceBetweenDots) * temp).toDouble();

      _shouldAdjustPosition?.cancel();
      if (actualOffset > circleRadius) {
        _shouldAdjustPosition = Timer(const Duration(milliseconds: 200), () {
          _scrollController.animateTo(actualOffset, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          final state = context.read<TimerBloc>().state;
          if (state is TimerPickedState) {
            Timer(const Duration(milliseconds: 600), () {
              context.read<TimerBloc>().add(TimerLoadingEvent(circlesAboveLine));
            });
          }
          if (state is TimerLoadedChangeState) {
            Timer(const Duration(milliseconds: 1000), () {
              context.read<TimerBloc>().add(TimerLoadedEvent(circlesAboveLine));
            });
          }
        });
      } else {
        final state = context.read<TimerBloc>().state;
        if (state is TimerLoadedChangeState) context.read<TimerBloc>().add(TimerLoadedEvent(circlesAboveLine));
      }
    }
  }

  void _calculateCirclesAboveLine() {
    offset.value = _scrollController.offset;

    int temp = ((_scrollController.offset) / ((circleRadius * 2) + spaceBetweenDots)).floor();

    if (temp > maxTime) temp = maxTime;

    final state = context.read<TimerBloc>().state;

    if (temp != circlesAboveLine || state is TimerLoadedState) {
      if (state is TimerLoadedState || state is TimerLoadedChangeState) {
        if (!changeBlocked) {
          circlesAboveLine = temp;
          context.read<TimerBloc>().add(TimerLoadedChangeEvent(circlesAboveLine));
        }
      } else {
        circlesAboveLine = temp;
        context.read<TimerBloc>().add(TimerChangeEvent(circlesAboveLine));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(_calculateCirclesAboveLine);
      _scrollController.position.isScrollingNotifier.addListener(_positionAdjust);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _shouldAdjustPosition?.cancel();
    _scrollController.removeListener(_calculateCirclesAboveLine);
    _scrollController.removeListener(_positionAdjust);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Stack(
                children: [
                  CircleList(height: height),
                  BottomOverlay(offset: offset, height: height),
                ],
              ),
            ),
            TimerTexts(height: height),
            BlocConsumer<TimerBloc, TimerState>(
              listener: (context, state) {
                if (state is TimerLoadedState || state is TimerFinishedState) {
                  if (!(state is TimerFinishedState && !state.soundVibration)) {
                    FlutterBeep.beep();
                    Vibrate.vibrate();
                  }
                }
                if (state is TimerPickedState) {
                  menuValue.value = MenuValue.hidden;
                }
                if (state is TimerInitialState || state is TimerFinishedState) {
                  menuValue.value = MenuValue.closed;
                }
              },
              listenWhen: (previous, current) {
                if ((previous is! TimerInitialState && current is TimerInitialState) || (previous is! TimerPickedState && current is TimerPickedState)) {
                  return true;
                }
                if ((previous is TimerLoadingState && current is TimerLoadedState) || (previous is! TimerFinishedState && current is TimerFinishedState)) {
                  return true;
                }
                return false;
              },
              buildWhen: (previous, current) {
                if ((previous is! TimerLoadedState && current is TimerLoadedState) || (previous is TimerLoadedState && current is! TimerLoadedState)) {
                  return true;
                }
                if ((previous is! TimerLoadingState && current is TimerLoadingState) || (previous is TimerLoadingState && current is! TimerLoadingState)) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TimerLoadingState) {
                  return TimerLoadingOverlay(height: height);
                }
                if (state is TimerLoadedState) {
                  return TimerLoadedOverlay(height: height, scrollController: _scrollController, blockChange: blockChange);
                }
                return const SizedBox.shrink();
              },
            ),
            FloatingButton(menuValue: menuValue),
            Container(width: double.infinity, height: 50, color: Colors.transparent),
          ],
        ),
      ),
    );
  }
}
