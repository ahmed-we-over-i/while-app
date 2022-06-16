import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';

void playSoundAndVibration(TimerState state, SettingsLoadedState settingsState) async {
  if (state is TimerLoadedState && !settingsState.settings.warmup) return;

  if (settingsState.settings.sound) {
    final player = AudioPlayer();

    String? fileName;

    if (state is TimerLoadedState) {
      fileName = settingsState.settings.startChime;
    } else {
      fileName = settingsState.settings.endChime;
    }

    await player.setAsset("assets/sounds/" + fileName + ".mp3");

    player.play();
  }
  if (settingsState.settings.vibration) {
    await Vibrate.vibrate();
  }
}
