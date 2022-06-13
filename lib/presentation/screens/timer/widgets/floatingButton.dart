import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/history/historyScreen.dart';
import 'package:while_app/presentation/screens/settings/settingsScreen.dart';
import 'package:while_app/presentation/screens/colors.dart';
import 'package:while_app/presentation/screens/timer/misc/enums.dart';

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
                            color: myColor.withOpacity(_animation.value * bgOpacity),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: EdgeInsets.only(bottom: _animation.value * 120),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingScreen()));
                            },
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.settings,
                              size: 20,
                              color: myColor.withOpacity(_animation.value * iconOpactiy),
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, _) => Container(
                          decoration: BoxDecoration(
                            color: myColor.withOpacity(_animation.value * bgOpacity),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: EdgeInsets.only(bottom: _animation.value * 60),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen()));
                            },
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: myColor.withOpacity(_animation.value * iconOpactiy),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: myColor.withOpacity(bgOpacity),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (widget.menuValue.value == MenuValue.open) {
                              widget.menuValue.value = MenuValue.closed;
                              _menuController.reverse();
                            } else {
                              widget.menuValue.value = MenuValue.open;
                              _menuController.forward();
                            }
                          },
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                          icon: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.5).animate(_menuController),
                            child: Icon(Icons.expand_less_rounded, size: 25, color: myColor.withOpacity(iconOpactiy)),
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
