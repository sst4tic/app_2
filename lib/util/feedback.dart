import 'package:yiwumart/util/product.dart';

class FeedbackModel {
  FeedbackModel({
    required this.id,
    required this.product,
    required this.rating,
    required this.body,
    required this.status,
    required this.date,
  });
  late final int id;
  late final Product product;
  late final int rating;
  late final String body;
  late final int status;
  late final String date;

  FeedbackModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    product = Product.fromJson(json['product']);
    rating = json['rating'];
    body = json['body'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['product'] = product.toJson();
    data['rating'] = rating;
    data['body'] = body;
    data['status'] = status;
    data['date'] = date;
    return data;
  }
}

