import 'dart:async';

import 'package:hive/hive.dart';

class HistoryRepository {
  Map<DateTime, Map<DateTime, int>> _history = {};

  bool fetched = false;

  Future<Map<DateTime, Map<DateTime, int>>> fetchHistory() async {
    if (!fetched) {
      var box = await Hive.openBox('myBox');
      final Map<DateTime, dynamic> temp = Map<DateTime, dynamic>.from(box.get('history') ?? {});

      temp.forEach((key, value) {
        _history[key] = Map<DateTime, int>.from(value ?? {});
      });

      fetched = true;
    }

    return _history;
  }

  Future<Map<DateTime, int>> fetchSession(DateTime dateTime) async {
    await fetchHistory();

    return _history[dateTime] ?? {};
  }

  bool sessionGoingOn = false;
  DateTime? currentSession;

  Future<void> _save(int minutes) async {
    await fetchHistory();

    if (!sessionGoingOn) {
      sessionGoingOn = true;
      final now = DateTime.now();

      currentSession = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    }

    final DateTime day = DateTime(currentSession!.year, currentSession!.month, currentSession!.day);

    if (!_history.containsKey(day)) {
      _history[day] = {};
    }

    if (_history[day]!.containsKey(currentSession!)) {
      _history[day]![currentSession!] = _history[day]![currentSession!]! + minutes;
    } else {
      _history[day]![currentSession!] = minutes;
    }

    var box = await Hive.openBox('myBox');
    box.put('history', _history);
  }

  addToHistory(int minutes) async {
    if (minutes > 0) {
      await _save(minutes);
    }

    print(_history);
  }

  endSession() {
    sessionGoingOn = false;
    currentSession = null;

    print("session ended");
  }
}
