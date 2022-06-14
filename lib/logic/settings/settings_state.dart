part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitialState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final Settings settings;

  const SettingsLoadedState({required this.settings});

  @override
  List<Object> get props => [settings.sound, settings.vibration, settings.mode, settings.theme, settings.warmup, settings.timer];
}
