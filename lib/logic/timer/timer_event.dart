part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {
  final int value;

  const TimerEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class TimerChangeEvent extends TimerEvent {
  const TimerChangeEvent(int value) : super(value);
}

class TimerLoadingEvent extends TimerEvent {
  const TimerLoadingEvent(int value) : super(value);
}

class TimerLoadedEvent extends TimerEvent {
  const TimerLoadedEvent(int value) : super(value);
}

class TimerLoadedChangeEvent extends TimerEvent {
  const TimerLoadedChangeEvent(int value) : super(value);
}

class TimerFinishedEvent extends TimerEvent {
  final bool soundVibration;

  const TimerFinishedEvent({this.soundVibration = false}) : super(0);

  @override
  List<Object?> get props => [value];
}
