part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitialState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final DateTime dateTime;
  final Map<DateTime, int> sessions;
  final Map<DateTime, Map<DateTime, int>> history;

  HistoryLoadedState({required this.dateTime, required this.sessions, required this.history});

  @override
  List<Object> get props => [dateTime, sessions, history];
}
