import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/history/widgets/calendarWidget.dart';
import 'package:while_app/presentation/screens/history/widgets/sessionsListWidget.dart';
import 'package:while_app/presentation/screens/timer/misc/enums.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          final mode = state.settings.mode;

          return Scaffold(
            backgroundColor: (mode == ColorMode.light) ? Color(0xFFFAFAFA) : Color(0xFF2A2A2A),
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
                    'History',
                    style: TextStyle(color: (mode == ColorMode.light) ? Colors.black87 : Colors.white, fontWeight: (mode == ColorMode.light) ? FontWeight.w500 : FontWeight.w400),
                  ),
                  padding: const EdgeInsetsDirectional.only(top: 5, start: 10, end: 10),
                  backgroundColor: (mode == ColorMode.light) ? Colors.white : Color(0xFF3A3A3A),
                  border: Border(bottom: BorderSide(width: 0.3, color: (mode == ColorMode.light) ? Colors.grey : Colors.white30)),
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CalendarWidget(mode: mode),
                    SizedBox(height: 40),
                    SessionsListWidget(mode: mode),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
