import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/history/historyScreen.dart';
import 'package:while_app/presentation/screens/settings/settingsScreen.dart';
import 'package:while_app/presentation/misc/colors.dart';
import 'package:while_app/presentation/misc/enums.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({Key? key, required this.menuValue}) : super(key: key);

  final ValueNotifier<MenuValue> menuValue;

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> with SingleTickerProviderStateMixin {
  late final AnimationController _menuController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_menuController);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          CustomTheme customTheme = GetColors(state.settings.theme, state.settings.mode);
          Color myColor = customTheme.foregroundColor;
          double bgOpacity = 0.15;
          double iconOpactiy = 0.6;

          return ValueListenableBuilder(
            valueListenable: widget.menuValue,
            builder: (context, value, __) {
              return Positioned(
                right: 25,
                bottom: 25,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: (value != MenuValue.hidden) ? 1 : 0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, _) => GestureDetector(
                          onTap: () {
                            widget.menuValue.value = MenuValue.closed;
                            _menuController.reverse();

                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingScreen()));
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              decoration: BoxDecoration(color: myColor.withOpacity(_animation.value * bgOpacity), borderRadius: BorderRadius.circular(30)),
                              width: 38,
                              height: 38,
                              margin: EdgeInsets.only(bottom: _animation.value * (90 + 24)),
                              child: Icon(Icons.settings, size: 20, color: myColor.withOpacity(_animation.value * iconOpactiy)),
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, _) => GestureDetector(
                          onTap: () {
                            widget.menuValue.value = MenuValue.closed;
                            _menuController.reverse();

                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen()));
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              decoration: BoxDecoration(color: myColor.withOpacity(_animation.value * bgOpacity), borderRadius: BorderRadius.circular(30)),
                              margin: EdgeInsets.only(bottom: _animation.value * (45 + 12)),
                              width: 38,
                              height: 38,
                              child: Icon(Icons.calendar_today, size: 16, color: myColor.withOpacity(_animation.value * iconOpactiy)),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (widget.menuValue.value == MenuValue.open) {
                            widget.menuValue.value = MenuValue.closed;
                            _menuController.reverse();
                          } else {
                            widget.menuValue.value = MenuValue.open;
                            _menuController.forward();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: myColor.withOpacity(bgOpacity),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            width: 38,
                            height: 38,
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5).animate(_menuController),
                              child: Icon(Icons.expand_less_rounded, size: 25, color: myColor.withOpacity(iconOpactiy)),
                            ),
                          ),
                        ),
                      ),
                    ],
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
