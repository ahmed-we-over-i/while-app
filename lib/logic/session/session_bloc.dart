import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:while_app/data/repositories/historyRepository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final HistoryRepository _historyRepository;

  SessionBloc({required HistoryRepository historyRepository})
      : _historyRepository = historyRepository,
        super(SessionInitialState()) {
    on<SessionIncrementEvent>((event, emit) {
      print("here1");
      _historyRepository.addToHistory(event.num);
    });
    on<SessionEndEvent>((event, emit) {
      print("here2");
      _historyRepository.endSession();
    });
  }
}
