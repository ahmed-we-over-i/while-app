import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:while_app/data/repositories/historyRepository.dart';
import 'package:while_app/data/repositories/settingsRepository.dart';
import 'package:while_app/logic/history/history_bloc.dart';
import 'package:while_app/logic/session/session_bloc.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:while_app/presentation/screens/timer/misc/functions.dart';
import 'package:while_app/presentation/screens/timer/timerScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await initializeNotification();

  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => SettingsRepository(), lazy: false),
        RepositoryProvider(create: (context) => HistoryRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(settingsRepository: context.read<SettingsRepository>())..add(SettingsFetchEvent()),
            lazy: false,
          ),
          BlocProvider<HistoryBloc>(create: (context) => HistoryBloc(historyRepository: context.read<HistoryRepository>())),
          BlocProvider<SessionBloc>(create: (context) => SessionBloc(historyRepository: context.read<HistoryRepository>())),
          BlocProvider<TimerBloc>(create: (context) => TimerBloc(sessionBloc: context.read<SessionBloc>()), lazy: false),
        ],
        child: MaterialApp(
          title: 'While',
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          home: Theme(
            child: const TimerScreen(),
            data: ThemeData(fontFamily: 'Apercu', primaryColor: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
