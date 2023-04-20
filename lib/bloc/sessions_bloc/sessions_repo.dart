import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yiwumart/util/session.dart';
import '../../util/constants.dart';
import 'abstract_sessions.dart';

class SessionsRepository implements AbstractSessions {
 @override
  Future<Session> getSessions() async {
    var url = '${Constants.API_URL_DOMAIN}action=sessions';
    final response = await http.get(
      Uri.parse(url),
      headers: Constants.headers()
    );
    final body = jsonDecode(response.body);
    final sessions = Session.fromJson(body);
    return sessions;
  }
  @override
  Future destroySession(String id) async {
    var url = '${Constants.API_URL_DOMAIN}action=sessions_destroy&id=$id';
    final response = await http.get(
      Uri.parse(url),
      headers: Constants.headers()
    );
    final body = jsonDecode(response.body);
    return body;
  }
  @override
  Future destroyAllSessions({required String pass}) async {
    var url = '${Constants.API_URL_DOMAIN}action=all_sessions_destroy&password=$pass';
    final response = await http.get(
      Uri.parse(url),
      headers: Constants.headers()
    );
    final body = jsonDecode(response.body);
    return body;
  }
}