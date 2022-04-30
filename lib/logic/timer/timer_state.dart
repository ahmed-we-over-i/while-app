part of 'timer_bloc.dart';

@immutable
abstract class TimerState extends Equatable {
  final int value;

  const TimerState(this.value);

  @override
  List<Object?> get props => [value];
}

class TimerInitialState extends TimerState {
  const TimerInitialState() : super(0);
}

class TimerPickedState extends TimerState {
  const TimerPickedState(int value) : super(value);
}

class TimerLoadingState extends TimerState {
  const TimerLoadingState(int value) : super(value);
}

class TimerLoadedState extends TimerState {
  const TimerLoadedState(int value) : super(value);
}

class TimerLoadedChangeState extends TimerState {
  const TimerLoadedChangeState(int value) : super(value);
}

class TimerFinishedState extends TimerState {
  const TimerFinishedState() : super(0);
}
