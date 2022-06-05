import 'package:hive/hive.dart';

class HistoryRepository {
  Map<DateTime, Map<DateTime, int>> _history = {};

  bool fetched = false;

  Future<void> fetchHistory() async {
    if (!fetched) {
      var box = await Hive.openBox('myBox');
      final Map<DateTime, dynamic> temp = Map<DateTime, dynamic>.from(box.get('history') ?? {});

      temp.forEach((key, value) {
        _history[key] = Map<DateTime, int>.from(value ?? {});
      });

      fetched = true;
    }
  }

  Future<Map<DateTime, int>> fetchSession(DateTime dateTime) async {
    await fetchHistory();

    return _history[dateTime] ?? {};
  }

  Future<void> _save(DateTime datetime, int minutes) async {
    await fetchHistory();

    final DateTime day = DateTime(datetime.year, datetime.month, datetime.day);

    if (!_history.containsKey(day)) {
      _history[day] = {};
    }

    _history[day]![datetime] = minutes;

    var box = await Hive.openBox('myBox');
    box.put('history', _history);
  }

  addToHistory(int minutes) async {
    if (minutes > 0) {
      await _save(DateTime.now(), minutes);
    }
  }
}
