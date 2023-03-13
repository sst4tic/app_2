class CartItem {
 CartItem({
  required this.items,
  required this.totalSum,
  required this.link,
 });
 late final List<Items> items;
 late String totalSum;
 late String link;

 CartItem.fromJson(Map<String, dynamic> json){
  items = List.from(json['items']).map((e)=>Items.fromJson(e)).toList();
  totalSum = json['total_sum'];
  link = json['link_checkout'];
 }

 Map<String, dynamic> toJson() {
  final _data = <String, dynamic>{};
  _data['items'] = items.map((e)=>e.toJson()).toList();
  _data['total_sum'] = totalSum;
  _data['link_checkout'] = link;
  return _data;
 }
}

class Items {
 Items({
  required this.id,
  required this.name,
  required this.price,
  required this.qty,
  required this.total,
  required this.imageThumb,
  required this.link,
 });
 late final int id;
 late final String name;
 late final String price;
 late int qty;
 late final String total;
 late final String imageThumb;
 late final String link;

 Items.fromJson(Map<String, dynamic> json){
  id = json['id'];
  name = json['name'];
  price = json['price'];
  qty = json['qty'];
  total = json['total'];
  imageThumb = json['image_thumb'];
  link = json['link'];
 }

 Map<String, dynamic> toJson() {
  final _data = <String, dynamic>{};
  _data['id'] = id;
  _data['name'] = name;
  _data['price'] = price;
  _data['qty'] = qty;
  _data['total'] = total;
  _data['image_thumb'] = imageThumb;
  _data['link'] = link;
  return _data;
 }
}