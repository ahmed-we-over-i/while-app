import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

enum ColorMode {
  light,
  dark,
}

enum ColorTheme {
  grey,
  blue,
}

class Settings extends HiveObject {
  bool sound;
  bool vibration;
  ColorMode mode;
  ColorTheme theme;

  Settings({this.sound = true, this.vibration = true, this.mode = ColorMode.light, this.theme = ColorTheme.grey});

  Map<String, dynamic> toMap() {
    return {
      'sound': sound,
      'vibration': vibration,
      'mode': mode.name,
      'theme': theme.name,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      sound: map['sound'] ?? false,
      vibration: map['vibration'] ?? false,
      mode: ColorMode.values.byName(map['mode']),
      theme: ColorTheme.values.byName(map['theme']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) => Settings.fromMap(json.decode(source));
}
