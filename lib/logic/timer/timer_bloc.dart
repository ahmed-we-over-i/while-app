import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerInitialState()) {
    on<TimerChangeEvent>(_onChange);
    on<TimerLoadingEvent>(_onLoading);
    on<TimerLoadedEvent>(_onLoaded);
    on<TimerLoadedChangeEvent>(_onLoadedChange);
    on<TimerFinishedEvent>(_onFinished);
  }

  void _onChange(TimerChangeEvent event, Emitter<TimerState> emit) {
    if (event.value > 0) {
      emit(TimerPickedState(event.value));
    } else {
      if (state is TimerFinishedState) {
        emit(const TimerFinishedState());
      } else {
        emit(const TimerInitialState());
      }
    }
  }

  void _onLoading(TimerLoadingEvent event, Emitter<TimerState> emit) {
    emit(TimerLoadingState(event.value));
  }

  void _onLoaded(TimerLoadedEvent event, Emitter<TimerState> emit) {
    if (event.value > 0) {
      emit(TimerLoadedState(event.value));
    } else {
      emit(const TimerFinishedState());
    }
  }

  void _onLoadedChange(TimerLoadedChangeEvent event, Emitter<TimerState> emit) {
    if (event.value > 0) {
      emit(TimerLoadedChangeState(event.value));
    } else {
      emit(const TimerLoadedChangeState(0));
    }
  }

  void _onFinished(TimerFinishedEvent event, Emitter<TimerState> emit) {
    emit(const TimerFinishedState());
  }
}
