import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/designs/circle.dart';
import 'package:while_app/presentation/designs/circleBordered.dart';
import 'package:while_app/presentation/screens/countdownScreen.dart';
import 'package:while_app/presentation/widgets/timerLoadingOverlay.dart';

class PickTimeScreen extends StatefulWidget {
  const PickTimeScreen({Key? key}) : super(key: key);

  @override
  State<PickTimeScreen> createState() => _PickTimeScreenState();
}

enum MenuValue {
  hidden,
  closed,
  open,
}

class _PickTimeScreenState extends State<PickTimeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();

  int value = 0;

  ValueNotifier<double> offset = ValueNotifier(0);

  Timer? _scrolled;

  ValueNotifier<MenuValue> menuValue = ValueNotifier(MenuValue.closed);

  late final AnimationController _menuController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  late Animation _animation;

  void positionAdjust() {
    int temp = ((_controller.offset - 34) / 32).floor();
    if (temp > 90) temp = 90;
    double actualOffset = (34 + 32 * temp).toDouble();

    _scrolled?.cancel();
    if (actualOffset > 50) {
      _scrolled = Timer(const Duration(milliseconds: 200), () {
        _controller.animateTo(actualOffset, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
        context.read<TimerBloc>().add(TimerLoadingEvent(value));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_menuController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _controller.addListener(() {
        offset.value = _controller.offset;

        int temp = ((_controller.offset - 34) / 32).floor();
        if (temp > 90) temp = 90;

        if (temp != value) {
          value = temp;
          context.read<TimerBloc>().add(TimerChangeEvent(value));
        }
      });

      _controller.position.isScrollingNotifier.addListener(() {
        if (!_controller.position.isScrollingNotifier.value) {
          positionAdjust();
          if (value > 0) {
            menuValue.value = MenuValue.hidden;
          } else {
            menuValue.value = MenuValue.closed;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _scrolled?.cancel();
    _controller.dispose();
    _menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(210, 210, 210, 1),
              Color.fromRGBO(210, 210, 210, 1),
            ],
            stops: [0, 0.5, 0.5, 1],
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SingleChildScrollView(
              controller: _controller,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50 + MediaQuery.of(context).size.height / 2),
                      for (int i = 1; i <= 90; i++)
                        Container(
                          margin: const EdgeInsets.all(8),
                          height: 16,
                          width: double.infinity,
                          child: CustomPaint(painter: Circle(0, 1)),
                        ),
                      SizedBox(height: MediaQuery.of(context).size.height / 2),
                    ],
                  ),
                  BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      return ValueListenableBuilder(
                        valueListenable: offset,
                        builder: (BuildContext context, double value, Widget? child) {
                          return Container(
                            margin: EdgeInsets.only(top: value + MediaQuery.of(context).size.height / 2),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(210, 210, 210, (state is TimerLoadingState) ? 1 : 0),
                                  const Color.fromRGBO(210, 210, 210, 1),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                if (state is! TimerLoadingState) {
                  return Padding(
                    padding: EdgeInsets.only(left: 50, bottom: 50 + MediaQuery.of(context).size.height / 2, right: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: (state is TimerInitialState) ? 1 : 0,
                          duration: const Duration(milliseconds: 500),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 50),
                              child: Text('swipe up to start', style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: (state is TimerPickedState) ? 1 : 0,
                          duration: const Duration(milliseconds: 500),
                          child: Text((state is TimerPickedState) ? state.value.toString() + ' m' : '0 m', style: const TextStyle(fontSize: 22)),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            ValueListenableBuilder(
              valueListenable: menuValue,
              builder: (context, value, __) {
                return Positioned(
                  right: 40,
                  bottom: 40,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: (value != MenuValue.hidden) ? 1 : 0,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, _) => Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(200, 200, 200, 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.only(bottom: _animation.value * 120),
                            child: IconButton(
                              onPressed: () {},
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.settings,
                                size: 20,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              ),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, _) => Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(200, 200, 200, 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.only(bottom: _animation.value * 60),
                            child: IconButton(
                              onPressed: () {},
                              padding: const EdgeInsets.all(6),
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(200, 200, 200, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (menuValue.value == MenuValue.open) {
                                menuValue.value = MenuValue.closed;
                                _menuController.reverse();
                              } else {
                                menuValue.value = MenuValue.open;
                                _menuController.forward();
                              }
                            },
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            icon: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5).animate(_menuController),
                              child: const Icon(
                                Icons.expand_less_rounded,
                                size: 25,
                                color: Color.fromRGBO(130, 130, 130, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
