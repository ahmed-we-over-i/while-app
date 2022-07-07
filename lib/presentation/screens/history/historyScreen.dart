import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/presentation/screens/history/widgets/calendarWidget.dart';
import 'package:while_app/presentation/screens/history/widgets/sessionsListWidget.dart';
import 'package:while_app/presentation/misc/enums.dart';
import 'package:while_app/presentation/widgets/customAppBar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void didChangeDependencies() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoadedState) {
          final mode = state.settings.mode;

          return Scaffold(
            backgroundColor: (mode == ColorMode.light) ? Color(0xFFF4F4F4) : Color(0xFF1C1C1C),
            appBar: CustomAppBar(mode: mode, text: 'History'),
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
