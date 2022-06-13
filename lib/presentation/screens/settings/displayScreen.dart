import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/colors.dart';
import 'package:while_app/presentation/screens/timer/misc/enums.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          final mode = state.settings.mode;
          final theme = state.settings.theme;

          return Scaffold(
            backgroundColor: (mode == ColorMode.light) ? Color(0xFFFAFAFA) : Color(0xFF2C2C2C),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: SizedBox(
                height: 55,
                child: CupertinoNavigationBar(
                  leading: IconButton(
                    icon: Icon(Icons.close, size: 18, color: (mode == ColorMode.light) ? Colors.grey : Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  middle: Text(
                    'Display',
                    style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white, fontWeight: (mode == ColorMode.light) ? FontWeight.w500 : FontWeight.w400),
                  ),
                  padding: const EdgeInsetsDirectional.only(top: 5, start: 10, end: 10),
                  backgroundColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
                  border: Border(bottom: BorderSide(width: 0.3, color: (mode == ColorMode.light) ? Colors.grey : Colors.white30)),
                ),
              ),
            ),
            body: Column(
              children: [
                DisplayAppearances(mode: mode, theme: theme),
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}

class DisplayAppearances extends StatelessWidget {
  final ColorMode mode;
  final ColorTheme theme;

  const DisplayAppearances({Key? key, required this.mode, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.32;
    final width = MediaQuery.of(context).size.width * 0.35;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Preview based on the appearance settings given below',
            style: TextStyle(height: 1.5, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white70),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DisplayCard(height: height, width: width, mode: mode, text: 'LIGHT', theme: GetColors(theme, ColorMode.light)),
              DisplayCard(height: height, width: width, mode: mode, text: 'DARK', theme: GetColors(theme, ColorMode.dark)),
            ],
          )
        ],
      ),
    );
  }
}

class DisplayCard extends StatelessWidget {
  const DisplayCard({Key? key, required this.height, required this.width, required this.mode, required this.text, required this.theme}) : super(key: key);

  final double height;
  final double width;
  final ColorMode mode;
  final String text;
  final CustomTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white, width: 0.25),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.backgroundColor,
                theme.backgroundColor,
                theme.bottomColor,
                theme.bottomColor,
              ],
              stops: [0, 0.5, 0.5, 1],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Text('Swipe up to state', textAlign: TextAlign.center),
              ),
              Column(
                children: [],
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Text(text, style: TextStyle(height: 1.5, fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
      ],
    );
  }
}
