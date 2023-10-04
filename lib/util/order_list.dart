
class OrderList {
  final int id;
  final String title;
  final String statusName;
  final int status;
  final String date;
  final String total;
  final List<Products> products;

  const OrderList ({
    required this.id,
    required this.title,
    required this.statusName,
    required this.status,
    required this.date,
    required this.total,
    required this.products,
  });
  static OrderList fromJson(json) => OrderList(
    id: json['id'],
    title: json['title'],
    statusName: json['status_name'],
    status: json['status'],
    date: json['date'],
    total: json['total'],
    products: List.from(json['products']).map((e)=>Products.fromJson(e)).toList(),
  );
}

class Products {
  Products({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.imageThumb,
    required this.link,
  });
  late final int id;
  late final String title;
  late final String price;
  late final int quantity;
  late final String total;
  late final String imageThumb;
  late final String link;

  Products.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    price = json['price'];
    quantity = json['quantity'];
    total = json['total'];
    imageThumb = json['image_thumb'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['quantity'] = quantity;
    data['total'] = total;
    data['image_thumb'] = imageThumb;
    data['link'] = link;
    return data;
  }
}