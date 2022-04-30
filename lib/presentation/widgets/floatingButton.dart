import 'package:flutter/material.dart';
import 'package:while_app/presentation/enums.dart';
import 'package:while_app/presentation/screens/settingsScreen.dart';

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
                      color: const Color.fromRGBO(200, 200, 200, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: EdgeInsets.only(bottom: _animation.value * 120),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingScreen()));
                      },
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
    );
  }
}
