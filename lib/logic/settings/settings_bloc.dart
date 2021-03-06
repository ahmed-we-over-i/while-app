import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:while_app/data/models/settings.dart';
import 'package:while_app/data/repositories/settingsRepository.dart';
import 'package:while_app/presentation/misc/enums.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(SettingsInitialState()) {
    on<SettingsFetchEvent>(_onFetch);
    on<SettingsChangeSoundEvent>(_onChangeSound);
    on<SettingsChangeVibrationEvent>(_onChangeVibration);
    on<SettingsChangeColorModeEvent>(_onChangeColorMode);
    on<SettingsChangeColorThemeEvent>(_onChangeColorTheme);
    on<SettingsChangeWarmupEvent>(_onChangeWarmupEvent);
    on<SettingsChangeTimerEvent>(_onChangeTimerEvent);
    on<SettingsChangeStartChimeEvent>(_onChangeStartChimeEvent);
    on<SettingsChangeEndChimeEvent>(_onChangeEndChimeEvent);
  }

  _onFetch(SettingsFetchEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.fetch();
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeSound(SettingsChangeSoundEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeSound(event.value);
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeVibration(SettingsChangeVibrationEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeVibration(event.value);
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeColorMode(SettingsChangeColorModeEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeColorMode(event.value);
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeColorTheme(SettingsChangeColorThemeEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeColorTheme(event.value);
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeWarmupEvent(SettingsChangeWarmupEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeWarmup(event.value);
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeTimerEvent(SettingsChangeTimerEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeTimer(event.value);
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeStartChimeEvent(SettingsChangeStartChimeEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeStartChime(event.value);
    emit(SettingsLoadedState(settings: settings));
  }

  _onChangeEndChimeEvent(SettingsChangeEndChimeEvent event, Emitter<SettingsState> emit) async {
    final Settings settings = await _settingsRepository.changeEndChime(event.value);
    emit(SettingsLoadedState(settings: settings));
  }
}
