import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:while_app/presentation/screens/enums.dart';
import 'package:while_app/presentation/screens/sounds.dart';

class Settings extends HiveObject {
  bool sound;
  bool vibration;
  ColorMode mode;
  ColorTheme theme;
  bool warmup;
  int timer;
  late String startChime;
  late String endChime;

  Settings({
    String? startChime,
    String? endChime,
    this.sound = true,
    this.vibration = true,
    this.mode = ColorMode.light,
    this.theme = ColorTheme.grey,
    this.warmup = true,
    this.timer = 20,
  }) {
    this.startChime = (startChime != null) ? startChime : sounds.first;
    this.endChime = (endChime != null) ? endChime : sounds.first;
  }

  Map<String, dynamic> toMap() {
    return {
      'sound': sound,
      'vibration': vibration,
      'mode': mode.name,
      'theme': theme.name,
      'warmup': warmup,
      'timer': timer,
      'startChime': startChime,
      'endChime': endChime,
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
      startChime: map['startChime'] ?? sounds.first,
      endChime: map['endChime'] ?? sounds.first,
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) => Settings.fromMap(json.decode(source));
}
