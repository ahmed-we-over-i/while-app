enum ColorMode {
  light,
  dark,
}

enum ColorTheme {
  grey,
  blue,
}

class Settings {
  bool sound;
  bool vibration;
  ColorMode mode;
  ColorTheme theme;

  Settings({this.sound = true, this.vibration = true, this.mode = ColorMode.light, this.theme = ColorTheme.grey});
}
