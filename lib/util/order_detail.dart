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
  late List<Items> items;

  OrderDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    statusName = json['status_name'];
    status = json['status'];
    date = json['date'];
    total = json['total'];
    items = List.from(json['items']).map((e)=>Items.fromJson(e)).toList();
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

class Items {
  Items({
    required this.id,
    required this.title,
    required this.price,
    required this.qty,
    required this.total,
    required this.img,
    required this.link
  });
  late final int id;
  late final String title;
  late final String price;
  late int qty;
  late final String total;
  late final String img;
  late final String link;

  Items.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    price = json['price'];
    qty = json['quantity'];
    total = json['total'];
    img = json['image_thumb'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = title;
    data['price'] = price;
    data['qty'] = qty;
    data['total'] = total;
    data['image_thumb'] = img;
    data['link'] = link;
    return data;
  }
}