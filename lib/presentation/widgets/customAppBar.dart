import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/enums.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.mode, required this.text}) : super(key: key);

  final ColorMode mode;
  final String text;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: SizedBox(
        height: 55,
        child: CupertinoNavigationBar(
          leading: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(Icons.close, size: 18, color: (mode == ColorMode.light) ? Colors.grey : Colors.white70),
              onPressed: () => Navigator.of(context).pop(),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ),
          middle: Text(
            text,
            style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white, fontWeight: (mode == ColorMode.light) ? FontWeight.w500 : FontWeight.w400),
          ),
          padding: const EdgeInsetsDirectional.only(top: 5, start: 10, end: 10),
          backgroundColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
          border: Border(bottom: BorderSide(width: 0.4, color: (mode == ColorMode.light) ? Colors.grey : Colors.white30)),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55);
}
