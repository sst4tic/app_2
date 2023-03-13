class OrderList {
  final int id;
  final String title;
  final String statusName;
  final int status;
  final String date;
  final String total;

  const OrderList ({
    required this.id,
    required this.title,
    required this.statusName,
    required this.status,
    required this.date,
    required this.total,
  });
  static OrderList fromJson(json) => OrderList(
    id: json['id'],
    title: json['title'],
    statusName: json['status_name'],
    status: json['status'],
    date: json['date'],
    total: json['total'],
  );
}

