import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/colors.dart';
import 'package:while_app/presentation/screens/enums.dart';

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({Key? key, required this.mode, required this.theme}) : super(key: key);

  final ColorMode mode;
  final ColorTheme theme;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late ColorTheme selected;

  @override
  void initState() {
    super.initState();

    selected = widget.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (widget.mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: (widget.mode == ColorMode.light) ? Colors.black.withOpacity(0.6) : Colors.white60),
                  ),
                  style: TextButton.styleFrom(primary: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    context.read<SettingsBloc>().add(SettingsChangeColorThemeEvent(value: selected));
                    Navigator.of(context).pop();
                  },
                  child: Text('Done', style: TextStyle(color: (widget.mode == ColorMode.light) ? Colors.black.withOpacity(0.7) : Colors.white70)),
                  style: TextButton.styleFrom(primary: Colors.grey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 50, top: 20),
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 20, crossAxisSpacing: 20),
              shrinkWrap: true,
              children: [
                ...ColorTheme.values.map((e) {
                  final customTheme = GetColors(e, ColorMode.light);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = e;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: (selected == e) ? ((widget.mode == ColorMode.light) ? Colors.black87 : Colors.white) : Colors.transparent),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: customTheme.bottomColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.done,
                          size: 22,
                          color: (selected == e) ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
