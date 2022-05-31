import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  Timer? _timer;

  service.on('cancelService').listen((event) {
    print("cancel service");
    service.stopSelf();
  });

  service.on('startService').listen((event) {
    print("start service");
    if (event != null) {
      print(event['seconds']);
      _timer = Timer(Duration(seconds: event['seconds']), () {
        print("here");
        FlutterBeep.beep();
        Vibrate.vibrate();
      });
    }
  });

  service.on('stopService').listen((event) {
    print("stop service");
    _timer?.cancel();
  });
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}
