part of 'sessions_bloc.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();
}

class SessionsInitial extends SessionsState {
  @override
  List<Object> get props => [];
}

class SessionsLoading extends SessionsState {
  const SessionsLoading({this.completer});

  final Completer? completer;

  @override
  List<Object> get props => [];
}

class SessionsLoaded extends SessionsState {
  final List sessions;
  final String currentSession;

  const SessionsLoaded({required this.sessions, required this.currentSession});

  @override
  List<Object> get props => [sessions, currentSession];
}
