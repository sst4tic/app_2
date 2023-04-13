import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yiwumart/bloc/sessions_bloc/sessions_repo.dart';
part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionsRepository sessionsRepo;

  SessionsBloc(this.sessionsRepo) : super(SessionsInitial()) {
    on<LoadSessions>((event, emit) async {
      final sessions = await sessionsRepo.getSessions();
     if(state is! SessionsLoading) {
       emit(SessionsLoading(completer: event.completer));
     }
      emit(SessionsLoaded(sessions: sessions.data, currentSession: sessions.currentSession));
    });
    on<DestroySession>((event, emit) async {
      var resp = await sessionsRepo.destroySession(event.id);
      print(resp);
      if(resp['success'] == true) {
        add(const LoadSessions());
      }
    });
    on<DestroyAllSessions>((event, emit) async {
      var resp = await sessionsRepo.destroyAllSessions();
      print(resp);
      if(resp['success'] == true) {
        add(const LoadSessions());
      }
    });
  }
}
