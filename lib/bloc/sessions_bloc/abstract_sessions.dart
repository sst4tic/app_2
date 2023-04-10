import '../../util/session.dart';

abstract class AbstractSessions {
  Future<Session> getSessions();
}