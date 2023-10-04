class StatusProgressModel {
  StatusProgressModel({
    required this.statusName,
    required this.date,
    required this.enabled,
  });
  late final String statusName;
  late final String date;
  late final bool enabled;

  StatusProgressModel.fromJson(Map<String, dynamic> json){
    statusName = json['statusName'];
    date = json['date'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusName'] = statusName;
    _data['date'] = date;
    _data['enabled'] = enabled;
    return _data;
  }
}