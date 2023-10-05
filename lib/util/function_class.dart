import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/main.dart';
import 'package:yiwumart/models/posts_model.dart';
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
  Dio dio = Dio();

  // func for getting popular categories
  static Future<List<PopularCategories>> getPopularCategories() async {
    var url = '${Constants.API_URL_DOMAIN_V3}categories/popular';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    print(body);
    return body['data']
        .map<PopularCategories>(PopularCategories.fromJson)
        .toList();
  }

  // func for logout/delete actions
  Future<void> logoutActions() async {
    Func().getFirebaseToken();
    Constants.USER_TOKEN = '';
    Constants.bearer = '';
    Constants.cookie = '';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('login');
    pref.remove('cookie');
  }

  // func for reset password
  Future resetPassword(email) async {
    var url = '${Constants.API_URL_DOMAIN}action=reset_password&email=$email';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body;
  }

  // func for validate reset pass
  Future validateReset(code, email) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=reset_password_validate&code=$code&email=$email';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body;
  }

  // func for update pass after reset
  Future updatePassAfterReset(email, password) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=reset_password_update&email=$email&password=$password';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    return body;
  }
// for get user
  static Future<User> getUser() async {
    var url = '${Constants.API_URL_DOMAIN_V3}my';
    final response =
    await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    return User.fromJson(body['data']);
  }

  // func for change password
  Future changePassword({required pass, required newPass}) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=password_edit&password=$pass&newpassword=$newPass';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    return body;
  }

  // func for getting catalog
  Future<List<Catalog>> getCatalog() async {
    var url = '${Constants.API_URL_DOMAIN_V3}categories';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    final catalog = body['data'].map<Catalog>(Catalog.fromJson).toList();
    return catalog;
  }

  // func for getting similar products
  static Future<List<Product>> getSimilarProducts({catId, productId}) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=catalog&category_id=$catId&product_id=$productId';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    return List.from(body['data']?.map!((e) => Product.fromJson(e)).toList());
  }

  // func for getting products
  static Future<List<Product>> getProducts() async {
    var url = '${Constants.API_URL_DOMAIN_V3}products/products_of_day';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    print(body);
    return List.from(body['data']?.map!((e) => Product.fromJson(e)).toList());
  }

  //  func for getting posts
  static Future<List<PostsModel>> getPosts() async {
    var url = '${Constants.API_URL_DOMAIN_V3}posts';
    final response =
    await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    print(body);
    return List.from(body['data']?.map!((e) => PostsModel.fromJson(e)).toList());
  }

  // func for searching products
  static Future<Search> searchProducts({required String search, int? productId}) async {
    var url = '${Constants.API_URL_DOMAIN_V3}search?query_text=$search${productId != null ? '&product_id=$productId' : ''}';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
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
      margin: REdgeInsets.symmetric(horizontal: 5, vertical: 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            BorderSide(color: success ? Color(0xFF7CB07F) : Color(0xFFD3B7B6)),
      ),
      padding: REdgeInsets.symmetric(horizontal: 12),
      showCloseIcon: true,
      closeIconColor: Colors.grey[500],
      content: Row(
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error,
            color: success
                ? Color.fromRGBO(56, 153, 72, 1)
                : Color.fromRGBO(252, 47, 61, 1),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: success
                        ? Color.fromRGBO(56, 153, 72, 1)
                        : Color.fromRGBO(252, 47, 61, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: success
          ? Color.fromRGBO(231, 243, 229, 1)
          : Color.fromRGBO(255, 228, 225, 1),
    ));
  }

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

  // for show support
  Future showSupport(context) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        builder: (context) {
          return Container(
            height: 230.h,
            padding: REdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 8,
                  width: 120.w,
                ),
                SizedBox(height: 15.h),
                SvgPicture.asset(
                  'assets/img/logo.svg',
                  height: 25.h,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: REdgeInsets.all(10),
                        margin: REdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/inst.png',
                              width: 50.w,
                              height: 50.h,
                            ),
                            const Text(
                              'Instagram',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: REdgeInsets.only(right: 5),
                        padding: REdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/phone.png',
                              width: 50.w,
                              height: 50.h,
                            ),
                            const Text(
                              'Instagram',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: REdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/whatsapp.png',
                              width: 50.w,
                              height: 50.h,
                            ),
                            const Text(
                              'Instagram',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                const Text(
                  'Свяжитесь с нами любым удобным способом',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 14,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F0F0),
                    fixedSize: Size(1000, 35.h),
                  ),
                  child: const Text(
                    'Закрыть',
                    style: TextStyle(
                      color: Color(0xFF5E606B),
                      fontFamily: 'Noto Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

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
            contentPadding: EdgeInsets.all(0),
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
    if (Constants.USER_TOKEN != '') {
      var url =
          '${Constants.API_URL_DOMAIN}action=favorite_toggle&product_id=$productId';
      http.Response response =
          await http.get(Uri.parse(url), headers: Constants.headers());
      dynamic body = jsonDecode(response.body);
      if (body['message'] == 'ADDED') {
        onAdded?.call();
      } else {
        onRemoved?.call();
      }
    } else {
      showWarningDialog(
          context: navKey.currentState!.context,
          text: 'Для добавления в избранное необходимо войти в аккаунт');
    }
  }

  Future<void> addToFavItem({
    required int productId,
    VoidCallback? onAdded,
    VoidCallback? onRemoved,
  }) async {
    var url =
        '${Constants.API_URL_DOMAIN}action=favorite_toggle&product_id=$productId';
    http.Response response =
        await http.get(Uri.parse(url), headers: Constants.headers());
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
    try {
      var url = '${Constants.API_URL_DOMAIN_V3}cart/add';
      Map<String, dynamic> data = {
        "product_id": productId,
      };

      Response response = await dio.post(url,
          data: data, options: Options(headers: Constants.headers()));
      dynamic body = response.data;
      if (body['success']) {
        scakey.currentState?.updateBadgeCount(body['qty']);
        onSuccess?.call();
      } else {
        onFailure?.call();
        Func().onSubmit(context: context);
      }
    } on DioError catch (e) {
      Func().onSubmit(context: context);
      print('dio error: ${e.response?.data}');
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
        await http.get(Uri.parse(url), headers: Constants.headers());
      });
    }
  }

  // func for load notification list
  Future<List<NotificationClass>> getNotifications() async {
    var url = '${Constants.API_URL_DOMAIN_V3}notification/list';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    final notification = body['data']
        .map<NotificationClass>(NotificationClass.fromJson)
        .toList();
    return notification;
  }

  // func for load orders list
  Future<List<OrderList>> getOrders() async {
    var url = '${Constants.API_URL_DOMAIN_V3}order/list';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    final orders = body['data'].map<OrderList>(OrderList.fromJson).toList();
    return orders;
  }

  // func for load productItem data
  Future<ProductItem> getProduct({required int id}) async {
    var url = '${Constants.API_URL_DOMAIN_V3}products/$id';
    print(url);
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    return ProductItem.fromJson(body['data']);
  }

  // func for load orderDetails
  Future<OrderDetail> getOrderDetails({required int id}) async {
    var url = '${Constants.API_URL_DOMAIN_V3}order/$id';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    return OrderDetail.fromJson(body['data']);
  }

  // func for get init parameters
  Future<http.Response> getInitParams() async {
    var url = '${Constants.API_URL_DOMAIN}action=init_params';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      scakey.currentState?.updateBadgeCount(body['data']?['cart_count'] ?? 0);
    }
    return response;
  }

  // func for getting user device and browser name
  String getDeviceNameFromUserAgent(String userAgent) {
    RegExp regExp = RegExp(r'\(([^;]+);');
    Match? match = regExp.firstMatch(userAgent);
    if (match != null) {
      String deviceInfo = match.group(1) ?? '';
      return deviceInfo.trim();
    }
    return '';
  }

  String getBrowserNameFromUserAgent(String userAgent) {
    RegExp regExp = RegExp(r'([A-Za-z]+\/[\d\.]+)');
    Match? match = regExp.firstMatch(userAgent);
    if (match != null) {
      String browserInfo = match.group(1) ?? '';
      return browserInfo.trim();
    }
    return '';
  }

  // func for load unread unread count
  Future<int> getUnreadCount() async {
    var url = '${Constants.API_URL_DOMAIN_V3}notification/unread_count';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
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
      showWarningDialog(
          text: 'Для использования корзины необходимо войти в аккаунт',
          context: context);
    }
  }

  // for getting popular search
  Future<List<String>> getPopularSearch() async {
    var url = '${Constants.API_URL_DOMAIN_V3}search/popular';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    return List.from(body['data']?.map((e) => e.toString()).toList());
  }

  void showWarningDialog({
    required BuildContext context,
    required String text,
  }) =>
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            contentPadding: REdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            title: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/bag_error.svg',
                  height: 92,
                  width: 92,
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            children: <Widget>[
              ElevatedButton(
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

  void showLogoutDialog(
          {required BuildContext context,
          required VoidCallback submitCallback}) =>
      showDialog(
          context: context,
          builder: (dialogContext) {
            return SimpleDialog(
              contentPadding:
                  REdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              title: Container(
                margin: REdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/exit_icon.svg',
                      width: 92,
                      height: 92,
                    ),
                    const SizedBox(height: 5),
                    const Text('Предупреждение',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF414141),
                          fontSize: 22,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 5),
                    const Text(
                      'Вы уверены, что хотите \nвыйти из аккаунта?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF5B5B5B),
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F0F0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Отмена',
                            style: TextStyle(
                              color: Color(0xFF5E606B),
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          submitCallback.call();
                        },
                        child: const Text('Выйти',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });

  void showDelete(
          {required BuildContext context,
          required VoidCallback submitCallback}) =>
      showDialog(
          context: context,
          builder: (dialogContext) {
            return SimpleDialog(
              contentPadding:
                  REdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              title: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/delete_warning.svg',
                    width: 92,
                    height: 92,
                  ),
                  const SizedBox(height: 5),
                  const Text('Удаление аккаунта',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF414141),
                        fontSize: 22,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 5),
                  const Text(
                    'Вы уверены, что хотите \nудалить аккаунт?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5B5B5B),
                      fontSize: 15,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F0F0),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Отмена',
                            style: TextStyle(
                              color: Color(0xFF5E606B),
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          submitCallback.call();
                        },
                        child: const Text('Удалить',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });

  void showDeleteCart(
          {required BuildContext context,
          required VoidCallback submitCallback}) =>
      showDialog(
          context: context,
          builder: (dialogContext) {
            return SimpleDialog(
              contentPadding:
                  REdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              title: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/delete_cart.svg',
                    width: 92,
                    height: 92,
                  ),
                  const SizedBox(height: 5),
                  const Text('Удаление аккаунта',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF414141),
                        fontSize: 22,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 5),
                  const Text(
                    'Вы уверены, что хотите удалить все товары из корзины?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5B5B5B),
                      fontSize: 15,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F0F0),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Отмена',
                            style: TextStyle(
                              color: Color(0xFF5E606B),
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          submitCallback.call();
                        },
                        child: const Text('Удалить',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });

  void showDeleteFeedback(
      {required BuildContext context,
        required VoidCallback submitCallback}) =>
      showDialog(
          context: context,
          builder: (dialogContext) {
            return SimpleDialog(
              contentPadding:
              REdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              title: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/delete_feedback.svg',
                    width: 92,
                    height: 92,
                  ),
                  const SizedBox(height: 5),
                  const Text('Удаление отзыва',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF414141),
                        fontSize: 22,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 5),
                  const Text(
                    'Вы уверены, что хотите \nудалить отзыв?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5B5B5B),
                      fontSize: 15,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F0F0),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Отмена',
                            style: TextStyle(
                              color: Color(0xFF5E606B),
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          submitCallback.call();
                        },
                        child: const Text('Удалить',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });


  // for submit feedback success
  void showSuccessPurchase({required BuildContext context}) => showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          contentPadding: REdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          title: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/purchase_success.svg',
                width: 92,
                height: 92,
              ),
              const SizedBox(height: 5),
              const Text('Спасибо за заказ!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 22,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 5),
              const Text(
                'Ваш заказ успешно оформлен и отображен в Истории покупок',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('ОК',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
              ],
            ),
          ],
        );
      });

  /// for submit feedback success
  void showFeedbackSuccess({required BuildContext context}) => showDialog(
        context: context,
        builder: (dialogContext) {
          return SimpleDialog(
            contentPadding: REdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
            title: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/purchase_success.svg',
                  width: 92,
                  height: 92,
                ),
                const SizedBox(height: 5),
                const Text('Спасибо за ваш отзыв!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF414141),
                      fontSize: 22,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 5),
                const Text(
                  'Ваш отзыв будет опубликован на странице товара',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text('ОК',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          );
        });

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 12) {
      // Invalid phone number length
      return phoneNumber;
    }

    // Split the phone number into parts and add spaces
    String formattedNumber =
        "+${phoneNumber.substring(1, 2)} ${phoneNumber.substring(2, 5)} ${phoneNumber.substring(5, 8)} ${phoneNumber.substring(8)}";

    return formattedNumber;
  }

  void showSmsDialog({
    required BuildContext context,
    required String phone,
    required Stream<int> countStream,
    required Function(String) submitCallback,
    required VoidCallback restartCallback,
  }) =>
      showDialog(
          context: context,
          builder: (dialogContext) {
            return SimpleDialog(
              contentPadding:
                  REdgeInsets.symmetric(horizontal: 8, vertical: 10),
              titlePadding: REdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              title: StreamBuilder(
                  stream: countStream,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text('Введите код из SMS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF414141),
                              fontSize: 20,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(height: 5.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Код подтверждения отправлен на номер',
                                style: TextStyle(
                                  color: Color(0xFF565555),
                                  fontSize: 14,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '\n${formatPhoneNumber(phone)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.h),
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          // controller: _codeController,
                          animationType: AnimationType.fade,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          useHapticFeedback: true,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            inactiveColor: const Color(0xFFF4F4F4),
                            selectedColor:
                                const Color.fromRGBO(13, 110, 253, 1),
                            activeFillColor:
                                const Color.fromRGBO(13, 110, 253, 1),
                            activeColor: const Color(0xFFF4F4F4),
                            borderWidth: 1.5,
                            fieldHeight: 60,
                            fieldWidth: 60,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onCompleted: (value) async {
                            // startTimer();
                            submitCallback(value);
                          },
                          onChanged: (String value) {},
                        ),
                        SizedBox(height: 5.h),
                        snapshot.data != 0
                            ? Text(
                                'Отправить код повторно через ${snapshot.data ?? ''} секунд',
                                style: const TextStyle(
                                  color: Color(0xFF90979E),
                                  fontSize: 12,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => restartCallback.call(),
                                      text: ' Отправить код повторно',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(13, 110, 253, 1),
                                        fontSize: 12,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    );
                  }),
            );
          });
}
