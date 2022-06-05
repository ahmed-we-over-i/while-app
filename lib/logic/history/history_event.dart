part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class HistoryLoadEvent extends HistoryEvent {
  final DateTime dateTime;

  HistoryLoadEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
