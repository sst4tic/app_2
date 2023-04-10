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
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    final sessions = Session.fromJson(body);
    return sessions;
  }
}