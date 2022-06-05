part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class SessionIncrementEvent extends SessionEvent {
  final int num;

  SessionIncrementEvent({this.num = 1});

  @override
  List<Object> get props => [num];
}

class SessionEndEvent extends SessionEvent {}
