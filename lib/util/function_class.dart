import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:yiwumart/util/popular_catalog.dart';
import 'package:http/http.dart' as http;
import 'package:yiwumart/util/product.dart';
import 'package:yiwumart/util/search.dart';
import '../screens/main_screen.dart';
import 'constants.dart';

class Func {
  // func for getting popular categories
  static Future<List<PopularCategories>> getPopularCategories() async {
    var url = '${Constants.API_URL_DOMAIN}action=popular_categories';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body['data']
        .map<PopularCategories>(PopularCategories.fromJson)
        .toList();
  }

  // func for getting products
  static Future<List<Product>> getProducts() async {
    var url =
        '${Constants.API_URL_DOMAIN}action=products_of_day&token=${Constants
        .USER_TOKEN}';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return List.from(body['data'].map!((e) => Product.fromJson(e)).toList());
  }

  // func for searching products
  static Future<Search> searchProducts(search) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=search&token=${Constants
        .USER_TOKEN}&q=$search';
    final response = await http.get(Uri.parse(url));
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
  Widget buildFilterField(Map<String, dynamic> field, filterDefVal, filterVal, context) {
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
        '${Constants.API_URL_DOMAIN}action=favorite_toggle&token=${Constants
        .USER_TOKEN}&product_id=$productId';
    http.Response response = await http.get(
      Uri.parse(url),
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
        '${Constants
        .API_URL_DOMAIN}action=add_to_cart&product_id=$productId&token=${Constants
        .USER_TOKEN}';
    http.Response response = await http.get(
      Uri.parse(url),
    );
    dynamic body = jsonDecode(response.body);
    if (body['success']) {
      onSuccess?.call();
    } else {
      onFailure?.call();
      Func().showSnackbar(context, body['message'], body['success']);
      Func().onSubmit(context: context);
    }
  }

  Future<void> onSubmit({
    required context,
    VoidCallback? submitCallback,
  }) async {
    if (Constants.USER_TOKEN != '') {} else {
      submitCallback?.call();
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            title: const Text(
              'Пройдите регистрацию, чтобы добавлять в корзину',
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  scakey.currentState!.onItemTapped(3);
                },
                style: const ButtonStyle(alignment: Alignment.center),
                child: const Text('Пройти регистрацию'),
              ),
            ],
          );
        },
      );
    }
  }

}

