class Session {
  Session({
    required this.data,
    required this.currentSession,
  });
  late final List<Data> data;
  late final String currentSession;

  Session.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
    currentSession = json['currentSession'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['currentSession'] = currentSession;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.ipAddress,
    required this.userAgent,
    required this.lastActivity,
  });
  late final String id;
  late final String ipAddress;
  late final String userAgent;
  late final String lastActivity;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    ipAddress = json['ip_address'];
    userAgent = json['user_agent'];
    lastActivity = json['last_activity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ip_address'] = ipAddress;
    _data['user_agent'] = userAgent;
    _data['last_activity'] = lastActivity;
    return _data;
  }
}
