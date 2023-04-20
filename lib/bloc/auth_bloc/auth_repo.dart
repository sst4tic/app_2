import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/constants.dart';
import '../../util/function_class.dart';
import 'abstract_auth.dart';
import 'package:http/http.dart' as http;

class AuthRepo implements AbstractAuth {
  @override
  getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constants.USER_TOKEN = pref.getString('login') ?? "";
    Constants.bearer = 'Bearer ${pref.getString('login') ?? ""}';
    return pref.getString('login') ?? "";
  }

  @override
  getCookie() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constants.cookie = pref.getString('cookie') ?? '';
    return pref.getString('login') ?? "";
  }

  @override
  Future login(String email, String password, context) async {
    final Dio dio = Dio();
    final cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    try {
      Response response = await dio
          .get('${Constants.API_URL_DOMAIN}action=auth&', queryParameters: {
        "email": email,
        "password": password,
      });
      List<Cookie> cookies =
      await cookieJar.loadForRequest(Uri.parse(Constants.API_URL_DOMAIN));
      String cookie = cookies.map((c) => '${c.name}=${c.value}').join(';');
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('cookie', cookie);
      if (response.data['api_token'] != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('login', response.data['api_token']);
        Constants.cookie = pref.getString('cookie') ?? '';
        Constants.USER_TOKEN = response.data['api_token'];
        Constants.bearer = 'Bearer ${response.data['api_token']}';
      }
      Func().showSnackbar(
          context, response.data['message'], response.data['success']);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  @override
  getFirebaseToken() async {
    if (Constants.USER_TOKEN.isEmpty) {
      FirebaseMessaging.instance.deleteToken();
    } else {
      FirebaseMessaging.instance.getToken().then((value) async {
        var url =
            '${Constants.API_URL_DOMAIN}action=fcm_device_token_post&fcm_device_token=$value';
        var resp = await http.get(Uri.parse(url), headers: Constants.headers());
        return resp;
      });
    }
  }
  @override
  Future logout() async {
    final Dio dio = Dio();
    try {
      Response response = await dio.get(
          '${Constants.API_URL_DOMAIN}action=logout',
          options: Options(headers: Constants.headers()));
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('login', '');
      Constants.USER_TOKEN = '';
      Constants.bearer = '';
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  @override
  Future register(String email, String password, String name, String surname,
      context) async {
    final Dio dio = Dio();
    final cookieJar = CookieJar();
    try {
      Response response = await dio
          .get('${Constants.API_URL_DOMAIN}action=register&', queryParameters: {
        "email": email,
        "password": password,
        "name": name,
        "surname": surname
      });
      List<Cookie> cookies =
          await cookieJar.loadForRequest(Uri.parse(Constants.API_URL_DOMAIN));
      String cookie = cookies.map((c) => '${c.name}=${c.value}').join(';');
      if (cookie.isNotEmpty) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('cookie', cookie);
        Constants.cookie = pref.getString('cookie') ?? '';
      }
      if (response.data['api_token'] != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('login', response.data['api_token']);
        Constants.USER_TOKEN = response.data['api_token'];
        Constants.bearer = 'Bearer ${response.data['api_token']}';
      }
      Func().showSnackbar(
          context, response.data['message'], response.data['success']);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
