part of 'session_bloc.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

class SessionInitialState extends SessionState {}

class SessionOngoingState extends SessionState {
  final int minutes;

  SessionOngoingState({required this.minutes});

  @override
  List<Object> get props => [minutes];
}
