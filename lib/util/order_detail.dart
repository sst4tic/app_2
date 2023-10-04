import 'package:yiwumart/util/order_list.dart';

class OrderDetail {
  OrderDetail({
    required this.id,
    required this.title,
    required this.statusName,
    required this.status,
    required this.date,
    required this.total,
    required this.items,
  });
  late int id;
  late String title;
  late String statusName;
  late int status;
  late String date;
  late String total;
  late List<Products> items;

  OrderDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    statusName = json['status_name'];
    status = json['status'];
    date = json['date'];
    total = json['total'];
    items = List.from(json['products']).map((e)=>Products.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status_name'] = statusName;
    data['status'] = status;
    data['date'] = date;
    data['total'] = total;
    data['items'] = items.map((e)=>e.toJson()).toList();
    return data;
  }
}
