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
    final data = <String, dynamic>{};
    data['statusName'] = statusName;
    data['date'] = date;
    data['enabled'] = enabled;
    return data;
  }
}