import 'dart:ui';

import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  DartPluginRegistrant.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    DartPluginRegistrant.ensureInitialized();

    final player = AudioPlayer();

    if (task == "task" && inputData != null) {
      if (inputData['vibration'] == true) {
        await Vibrate.vibrate();
        print("here");
      }
      if (inputData['sound'] == true) {
        final fileName = inputData['chime'];

        await player.setAsset("assets/sounds/" + fileName + ".mp3");

        player.play();
        print("here");
      }
    }
    return Future.value(true);
  });
}
