import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: SizedBox(
            height: 65,
            child: CupertinoNavigationBar(
              leading: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              middle: const Text('History'),
              padding: const EdgeInsetsDirectional.only(top: 5, start: 10, end: 10),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        body: const SafeArea(child: CalendarWidget()),
      );
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Material(
          color: Colors.transparent,
          child: IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        middle: const Text('History'),
        padding: const EdgeInsetsDirectional.only(bottom: 10, start: 10, end: 10),
        backgroundColor: Colors.white,
      ),
      child: const Material(child: SafeArea(child: CalendarWidget())),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime current = DateTime.now();

  DateTime min = DateTime.now()..subtract(const Duration(days: 365 * 20));
  DateTime max = DateTime.now()..add(const Duration(days: 365 * 20));

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: current,
      firstDate: min,
      lastDate: max,
      onDateChanged: (value) {
        setState(() {
          current = value;
        });
      },
      selectableDayPredicate: (DateTime val) => true,
    );
  }
}
