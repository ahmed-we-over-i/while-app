import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:while_app/logic/settings/settings_bloc.dart';
import 'package:while_app/logic/timer/timer_bloc.dart';
import 'package:while_app/presentation/misc/extensions.dart';

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

    await player.setAsset("assets/sounds/" + fileName.removeSpacesAndLowercase + ".mp3");

    player.play();
  }
  if (settingsState.settings.vibration) {
    await Vibrate.vibrate();
  }
}

Future<void> initializeNotification() async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(channelKey: 'nil', channelName: 'nil', channelDescription: 'nil', playSound: false, enableVibration: false),
      NotificationChannel(channelKey: 'vibrate', channelName: 'vibrate', channelDescription: 'vibrate', playSound: false, enableVibration: true),
      NotificationChannel(
        channelKey: 'birds1',
        channelName: 'birds 1',
        channelDescription: 'birds 1',
        playSound: true,
        soundSource: 'resource://raw/res_birds1',
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: 'birds1vibrate',
        channelName: 'birds 1',
        channelDescription: 'birds 1',
        playSound: true,
        soundSource: 'resource://raw/res_birds1',
        enableVibration: true,
      ),
      NotificationChannel(
        channelKey: 'birds2',
        channelName: 'birds 2',
        channelDescription: 'birds 2',
        playSound: true,
        soundSource: 'resource://raw/res_birds2',
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: 'birds2vibrate',
        channelName: 'birds 2',
        channelDescription: 'birds 2',
        playSound: true,
        soundSource: 'resource://raw/res_birds2',
        enableVibration: true,
      ),
      NotificationChannel(
        channelKey: 'crystal1',
        channelName: 'crystal 1',
        channelDescription: 'crystal 1',
        playSound: true,
        soundSource: 'resource://raw/res_crystal1',
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: 'crystal1vibrate',
        channelName: 'crystal 1',
        channelDescription: 'crystal 1',
        playSound: true,
        soundSource: 'resource://raw/res_crystal1',
        enableVibration: true,
      ),
      NotificationChannel(
        channelKey: 'crystal2',
        channelName: 'crystal 2',
        channelDescription: 'crystal 2',
        playSound: true,
        soundSource: 'resource://raw/res_crystal2',
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: 'crystal2vibrate',
        channelName: 'crystal 2',
        channelDescription: 'crystal 2',
        playSound: true,
        soundSource: 'resource://raw/res_crystal2',
        enableVibration: true,
      ),
    ],
  );
}

Future<void> getNotificationPermissions() async {
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          NotificationPermission.PreciseAlarms,
          NotificationPermission.OverrideDnD,
        ],
      );
    }
  });
}

startNotification({required bool sound, required bool vibration, required String chime, required DateTime scheduled}) {
  String key = '';

  if (sound == false && vibration == false) {
    key = 'nil';
  } else {
    if (sound == true) {
      key += chime.removeSpacesAndLowercase;
    }
    if (vibration == true) {
      key += 'vibrate';
    }
  }

  AwesomeNotifications().createNotification(
    content: NotificationContent(id: 1, channelKey: key, title: 'Timer completed'),
    schedule: NotificationCalendar(
      year: scheduled.year,
      month: scheduled.month,
      day: scheduled.day,
      hour: scheduled.hour,
      minute: scheduled.minute,
      second: scheduled.second,
    ),
  );
}

stopNotifications() {
  AwesomeNotifications().cancelAll();
}
