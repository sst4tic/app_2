class CartItem {
 CartItem({
  required this.items,
  required this.totalSum,
  this.cartId,
 });
 late final List<Items> items;
 late String totalSum;
 late int? cartId;

 CartItem.fromJson(Map<String, dynamic> json){
  items = List.from(json['items']).map((e)=>Items.fromJson(e)).toList();
  totalSum = json['total_sum'];
  cartId = json['cart_id'];
 }

 Map<String, dynamic> toJson() {
  final data = <String, dynamic>{};
  data['items'] = items.map((e)=>e.toJson()).toList();
  data['total_sum'] = totalSum;
  data['cart_id'] = cartId;
  return data;
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
  final data = <String, dynamic>{};
  data['id'] = id;
  data['name'] = name;
  data['price'] = price;
  data['qty'] = qty;
  data['total'] = total;
  data['image_thumb'] = imageThumb;
  data['link'] = link;
  return data;
 }
}