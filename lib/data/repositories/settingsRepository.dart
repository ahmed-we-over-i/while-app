import 'package:while_app/data/models/settings.dart';

class SettingsRepository {
  Settings settings;

  SettingsRepository() : settings = Settings();

  bool fetched = true;

  Future<Settings> fetch() async {
    if (!fetched) {
      fetched = true;
    }

    return settings;
  }

  Future<Settings> changeSound(bool value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: value, vibration: settings.vibration, mode: settings.mode, theme: settings.theme);

    return settings;
  }

  Future<Settings> changeVibration(bool value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: settings.sound, vibration: value, mode: settings.mode, theme: settings.theme);

    return settings;
  }

  Future<Settings> changeColorMode(ColorMode value) async {
    if (!fetched) {
      await fetch();
    }

    settings = Settings(sound: settings.sound, vibration: settings.vibration, mode: value, theme: settings.theme);

    return settings;
  }
}
