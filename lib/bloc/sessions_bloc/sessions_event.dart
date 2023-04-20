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

class DestroySession extends SessionsEvent {
  const DestroySession({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [id];
}

class DestroyAllSessions extends SessionsEvent {
  const DestroyAllSessions({
    required this.context,
});

  final BuildContext context;

  @override
  List<Object?> get props => [];
}