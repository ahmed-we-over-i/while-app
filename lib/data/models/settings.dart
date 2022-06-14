import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:while_app/presentation/screens/enums.dart';

class Settings extends HiveObject {
  bool sound;
  bool vibration;
  ColorMode mode;
  ColorTheme theme;
  bool warmup;
  int timer;

  Settings({this.sound = true, this.vibration = true, this.mode = ColorMode.light, this.theme = ColorTheme.grey, this.warmup = true, this.timer = 20});

  Map<String, dynamic> toMap() {
    return {
      'sound': sound,
      'vibration': vibration,
      'mode': mode.name,
      'theme': theme.name,
      'warmup': warmup,
      'tiner': timer,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      sound: map['sound'] ?? true,
      vibration: map['vibration'] ?? true,
      mode: ColorMode.values.byName(map['mode'] ?? ColorMode.light),
      theme: ColorTheme.values.byName(map['theme'] ?? ColorTheme.grey),
      warmup: map['sound'] ?? true,
      timer: map['timer'] ?? 20,
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) => Settings.fromMap(json.decode(source));
}
