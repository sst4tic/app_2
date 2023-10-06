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
    required this.location,
  });
  late final String id;
  late final String ipAddress;
  late final String userAgent;
  late final String lastActivity;
  late final String location;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    ipAddress = json['ip_address'];
    userAgent = json['user_agent'];
    lastActivity = json['last_activity'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['ip_address'] = ipAddress;
    data['user_agent'] = userAgent;
    data['last_activity'] = lastActivity;
    data['location'] = location;
    return data;
  }
}
