import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:while_app/presentation/extensions.dart';
import 'package:while_app/presentation/screens/enums.dart';
import 'package:while_app/presentation/screens/settings/widgets/colorPickerWidget.dart';
import 'package:while_app/presentation/screens/settings/widgets/displayCard.dart';
import 'package:while_app/presentation/widgets/myDivider.dart';

class DisplayAppearances extends StatelessWidget {
  final ColorMode mode;
  final ColorTheme theme;

  const DisplayAppearances({Key? key, required this.mode, required this.theme}) : super(key: key);

  _buildThemePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: (mode == ColorMode.light) ? Colors.black26 : Colors.black38,
      builder: (BuildContext context) {
        return ColorPickerWidget(mode: mode, theme: theme);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.32;
    final width = MediaQuery.of(context).size.width * 0.35;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                    DisplayCard(height: height, width: width, mode: mode, text: 'LIGHT', theme: theme, cardMode: ColorMode.light),
                    DisplayCard(height: height, width: width, mode: mode, text: 'DARK', theme: theme, cardMode: ColorMode.dark),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          MyDivider(mode: mode),
          ListTile(
            title: Text("Color", style: TextStyle(fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
            tileColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(theme.name.inCaps, style: TextStyle(height: 1.5, fontSize: 16, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white)),
                SizedBox(width: 6),
                Icon(Icons.chevron_right, size: 30, color: (mode == ColorMode.light) ? Colors.grey : Colors.white70),
              ],
            ),
            onTap: () => _buildThemePicker(context),
          ),
          MyDivider(mode: mode),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Preview based on the appearance settings given below',
              style: TextStyle(height: 1.5, color: (mode == ColorMode.light) ? Colors.black87 : Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
