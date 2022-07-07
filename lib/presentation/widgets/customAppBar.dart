import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:while_app/presentation/misc/enums.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.mode, required this.text}) : super(key: key);

  final ColorMode mode;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(Icons.close, size: 18, color: (mode == ColorMode.light) ? Colors.grey : Colors.white70),
        ),
        onPressed: () => Navigator.of(context).pop(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      centerTitle: true,
      title: Text(
        text,
        style: TextStyle(
          color: (mode == ColorMode.light) ? Colors.black87 : Colors.white,
          fontWeight: (mode == ColorMode.light) ? FontWeight.w500 : FontWeight.w400,
          fontSize: 16,
        ),
      ),
      backgroundColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF2A2A2A),
      shadowColor: (mode == ColorMode.light) ? Colors.black54 : Colors.white54,
      elevation: 0.5,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
