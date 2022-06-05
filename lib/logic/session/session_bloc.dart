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
      if (state is SessionInitialState) {
        emit(SessionOngoingState(minutes: event.num));
      } else if (state is SessionOngoingState) {
        emit(SessionOngoingState(minutes: (state as SessionOngoingState).minutes + event.num));
      }
    });
    on<SessionEndEvent>((event, emit) {
      if (state is SessionOngoingState) {
        _historyRepository.addToHistory((state as SessionOngoingState).minutes);
      }
      emit(SessionInitialState());
    });
  }
}
