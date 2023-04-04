import 'dart:convert';
import 'package:yiwumart/util/cart_list.dart';
import '../../util/constants.dart';
import 'abstract_bag.dart';
import 'package:http/http.dart' as http;

class BagRepository implements AbstractBag {
  @override
  Future<CartItem> getBagList() async {
    var url = '${Constants.API_URL_DOMAIN}action=cart_list';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    final cart = CartItem.fromJson(body['data']);
    return cart;
  }
  @override
  Future changeQuantity(int id, int quantity) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=cart_product_qty&product_id=$id&qty=$quantity';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    return body;
  }
}