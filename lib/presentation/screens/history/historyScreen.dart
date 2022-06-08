import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/history/widgets/calendarWidget.dart';
import 'package:while_app/presentation/screens/history/widgets/sessionsListWidget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: SizedBox(
          height: 55,
          child: CupertinoNavigationBar(
            leading: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            middle: const Text('History'),
            padding: const EdgeInsetsDirectional.only(top: 5, start: 10, end: 10),
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CalendarWidget(),
              SizedBox(height: 40),
              SessionsListWidget(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
