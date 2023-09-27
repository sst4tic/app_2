import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:yiwumart/util/cart_list.dart';
import '../../util/constants.dart';
import 'abstract_bag.dart';
import 'package:http/http.dart' as http;

class BagRepository implements AbstractBag {
  @override
  Future<CartItem> getBagList() async {
    var url = '${Constants.API_URL_DOMAIN}action=cart_list';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    final cart = CartItem.fromJson(body['data']);
    return cart;
  }

  @override
  Future changeQuantity(int id, int quantity) async {
    Dio dio = Dio();
    var url = '${Constants.API_URL_DOMAIN_V3}cart/product_qty';
    Map<String, dynamic> data = {
      "product_id": id,
      "qty": quantity,
    };
    final Response response = await dio.post(
      url,
      data: FormData.fromMap(data),
      options: Options(
        headers: Constants.headers(),
      ),
    );
    final body = response.data;
    return body;
  }

  @override
  Future deleteSelected(Set<int> ids) async {
    try {
      Dio dio = Dio();
      var url = '${Constants.API_URL_DOMAIN_V3}cart/delete-product';
      Map<String, dynamic> data = {
        "selectedProducts": ids.toList(),
      };
      final Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: Constants.headers(),
        ),
      );
      final body = response.data;
      return body;
    } on DioError catch (e) {
      print(e.stackTrace);
      print(e.response!.data);
    }
  }
}
