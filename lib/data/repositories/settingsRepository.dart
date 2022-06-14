import 'package:hive_flutter/hive_flutter.dart';
import 'package:while_app/data/models/settings.dart';
import 'package:while_app/presentation/screens/enums.dart';

class SettingsRepository {
  Settings settings;

  SettingsRepository() : settings = Settings();

  bool fetched = false;

  Future<void> _save() async {
    var box = await Hive.openBox('myBox');
    box.put("settings", settings.toMap());
  }

  Future<Settings> fetch() async {
    if (!fetched) {
      var box = await Hive.openBox('myBox');

      final temp = box.get("settings");

      if (temp == null) {
        box.put("settings", settings.toMap());
      } else {
        final _map = Map<String, dynamic>.from(temp);
        settings = Settings.fromMap(_map);
      }

      fetched = true;
    }

    return settings;
  }

  Future<Settings> changeSound(bool value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: value, vibration: settings.vibration, mode: settings.mode, theme: settings.theme, warmup: settings.warmup, timer: settings.timer);

    await _save.call();

    return settings;
  }

  Future<Settings> changeVibration(bool value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: settings.sound, vibration: value, mode: settings.mode, theme: settings.theme, warmup: settings.warmup, timer: settings.timer);

    await _save.call();

    return settings;
  }

  Future<Settings> changeColorMode(ColorMode value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: settings.sound, vibration: settings.vibration, mode: value, theme: settings.theme, warmup: settings.warmup, timer: settings.timer);

    await _save.call();

    return settings;
  }

  Future<Settings> changeColorTheme(ColorTheme value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: settings.sound, vibration: settings.vibration, mode: settings.mode, theme: value, warmup: settings.warmup, timer: settings.timer);

    await _save.call();

    return settings;
  }

  Future<Settings> changeWarmup(bool value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: settings.sound, vibration: settings.vibration, mode: settings.mode, theme: settings.theme, warmup: value, timer: settings.timer);

    await _save.call();

    return settings;
  }

  Future<Settings> changeTimer(int value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: settings.sound, vibration: settings.vibration, mode: settings.mode, theme: settings.theme, warmup: settings.warmup, timer: value);

    await _save.call();

    return settings;
  }
}
