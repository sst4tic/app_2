part of 'sessions_bloc.dart';

abstract class SessionsEvent extends Equatable {
  const SessionsEvent();
}

class LoadSessions extends SessionsEvent {
  const LoadSessions({
    this.completer,
  });

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}