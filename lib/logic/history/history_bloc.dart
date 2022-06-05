import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:while_app/data/repositories/historyRepository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryBloc({required HistoryRepository historyRepository})
      : _historyRepository = historyRepository,
        super(HistoryInitialState()) {
    on<HistoryLoadEvent>((event, emit) async {
      final sessions = await _historyRepository.fetchSession(event.dateTime);

      emit(HistoryLoadedState(dateTime: event.dateTime, sessions: sessions));
    });
  }
}
