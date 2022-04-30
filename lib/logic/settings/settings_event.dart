part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsFetchEvent extends SettingsEvent {}

class SettingsChangeSoundEvent extends SettingsEvent {
  final bool value;

  const SettingsChangeSoundEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class SettingsChangeVibrationEvent extends SettingsEvent {
  final bool value;

  const SettingsChangeVibrationEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class SettingsChangeColorModeEvent extends SettingsEvent {
  final ColorMode value;

  const SettingsChangeColorModeEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class SettingsChangeColorThemeEvent extends SettingsEvent {}
