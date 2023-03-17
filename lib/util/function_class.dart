import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:yiwumart/util/cart_list.dart';
import 'package:yiwumart/util/order_list.dart';
import 'package:yiwumart/util/popular_catalog.dart';
import 'package:http/http.dart' as http;
import 'package:yiwumart/util/product.dart';
import 'package:yiwumart/util/product_item.dart';
import 'package:yiwumart/util/search.dart';
import '../screens/main_screen.dart';
import 'catalog.dart';
import 'constants.dart';
import 'notification.dart';
import 'order_detail.dart';

class Func {
  // func for getting popular categories
  static Future<List<PopularCategories>> getPopularCategories() async {
    var url = '${Constants.API_URL_DOMAIN}action=popular_categories';
    final response = await http.get(Uri.parse(url), headers: {
      Constants.header: Constants.bearer,
    });
    final body = jsonDecode(response.body);
    return body['data']
        .map<PopularCategories>(PopularCategories.fromJson)
        .toList();
  }

  // func for getting catalog
  Future<List<Catalog>> getCatalog() async {
    var url = '${Constants.API_URL_DOMAIN}action=categories';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    final catalog = body['data'].map<Catalog>(Catalog.fromJson).toList();
    return catalog;
  }

  // func for getting products
  static Future<List<Product>> getProducts() async {
    var url = '${Constants.API_URL_DOMAIN}action=products_of_day';
    final response = await http.get(Uri.parse(url), headers: {
      Constants.header: Constants.bearer,
    });
    final body = jsonDecode(response.body);
    return List.from(body['data']?.map!((e) => Product.fromJson(e)).toList());
  }

  // func for searching products
  static Future<Search> searchProducts(search) async {
    var url = '${Constants.API_URL_DOMAIN}action=search&q=$search';
    final response = await http.get(Uri.parse(url), headers: {
      Constants.header: Constants.bearer,
    });
    final body = jsonDecode(response.body);
    if (search != '') {
      return Search.fromJson(body['data']);
    } else {
      return Search.fromJson({});
    }
  }

// func for showing snackbar
  showSnackbar(context, String text, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style:
            TextStyle(color: success ? Colors.green : Colors.red, fontSize: 17),
      ),
      backgroundColor: Colors.black87,
    ));
  }

  // CustomScrollView SizedBox

  static SliverList sizedGrid = SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
      childCount: 1,
    ),
  );

  // func for building filter fields
  Widget buildFilterField(
      Map<String, dynamic> field, filterDefVal, filterVal, context) {
    List<Widget> children = [];
    for (var key in field.keys) {
      if (field[key]["type"] == 'radio') {
        filterDefVal[key] =
            field[key]["initial_value"]; // saving default values from api
        children.add(FormBuilderRadioGroup(
          initialValue: filterVal[key] ?? field[key]["initial_value"],
          name: field[key]["value"],
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          options: [
            for (var option in field[key]["data"])
              FormBuilderFieldOption(
                  value: option['value'],
                  child: Text(
                    option['text'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ))
          ],
        ));
      }
    }
    return children.isEmpty ? Container() : Column(children: children);
  }

  // func for adding/removing product to/from favorites
  Future<void> addToFav({
    required int productId,
    required int index,
    VoidCallback? onAdded,
    VoidCallback? onRemoved,
  }) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=favorite_toggle&product_id=$productId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    dynamic body = jsonDecode(response.body);
    if (body['message'] == 'ADDED') {
      onAdded?.call();
    } else {
      onRemoved?.call();
    }
  }

  Future<void> addToFavItem({
    required int productId,
    VoidCallback? onAdded,
    VoidCallback? onRemoved,
  }) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=favorite_toggle&product_id=$productId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    dynamic body = jsonDecode(response.body);
    if (body['message'] == 'ADDED') {
      onAdded?.call();
    } else {
      onRemoved?.call();
    }
  }

  // func for adding product to bag
  Future<void> addToBag({
    required int productId,
    context,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=add_to_cart&product_id=$productId';
    http.Response response = await http.get(Uri.parse(url), headers: {
      Constants.header: Constants.bearer,
    });
    dynamic body = jsonDecode(response.body);
    if (body['success']) {
      onSuccess?.call();
    } else {
      onFailure?.call();
      Func().showSnackbar(context, body['message'], body['success']);
      Func().onSubmit(context: context);
    }
  }

  // func for getting/deleting firebase token
  Future<void> getFirebaseToken() async {
    if (Constants.USER_TOKEN.isEmpty) {
      FirebaseMessaging.instance.deleteToken();
    } else {
      FirebaseMessaging.instance.getToken().then((value) async {
        var url =
            '${Constants.API_URL_DOMAIN}action=fcm_device_token_post&fcm_device_token=$value';
        await http.get(Uri.parse(url), headers: {
          Constants.header: 'Bearer ${Constants.USER_TOKEN}',
        });
      });
    }
  }

  // func for load notification list
  Future<List<NotificationClass>> getNotifications() async {
    var url = '${Constants.API_URL_DOMAIN}action=notifications_list';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    final notification = body['data']
        .map<NotificationClass>(NotificationClass.fromJson)
        .toList();
    return notification;
  }

  // func for load orders list
  Future<List<OrderList>> getOrders() async {
    var url = '${Constants.API_URL_DOMAIN}action=orders_list';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    final orders = body['data'].map<OrderList>(OrderList.fromJson).toList();
    return orders;
  }

  // func for load productItem data
  Future<ProductItem> getProduct({required int id}) async {
    var url = '${Constants.API_URL_DOMAIN}action=product_detail&product_id=$id';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    return ProductItem.fromJson(body['data']);
  }

  // func for load orderDetails
  Future<OrderDetail> getOrderDetails({required int id}) async {
    var url = '${Constants.API_URL_DOMAIN}action=order_details&cart_id=$id';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    return OrderDetail.fromJson(body['data']);
  }

  // func for load Cart data
  Future<CartItem> getCart() async {
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

  // func for load unread unread count
  Future<int> getUnreadCount() async {
    var url = '${Constants.API_URL_DOMAIN}action=notifications_unread_count';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        Constants.header: Constants.bearer,
      },
    );
    final body = jsonDecode(response.body);
    return body['unread_count'] ?? 0;
  }

  Future<void> onSubmit({
    required context,
    VoidCallback? submitCallback,
  }) async {
    if (Constants.USER_TOKEN != '') {
    } else {
      submitCallback?.call();
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            title: const Text(
              'Для использования корзины необходимо войти в аккаунт',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  scakey.currentState!.onItemTapped(3);
                },
                child: const Text('Войти в аккаунт'),
              ),
            ],
          );
        },
      );
    }
  }
}
