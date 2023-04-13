import '../../util/session.dart';

abstract class AbstractSessions {
  Future<Session> getSessions();
  Future destroySession(String id);
  Future destroyAllSessions();
}