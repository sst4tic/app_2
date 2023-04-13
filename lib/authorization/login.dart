import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/authorization/registration.dart';
import 'package:yiwumart/screens/profile_screen.dart';
import '../util/constants.dart';
import '../util/function_class.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _hidePass = true;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  void _fieldFocusChanged(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
        ),
        centerTitle: false,
      ),
      resizeToAvoidBottomInset: true,
      key: _scaffoldkey,
      body:Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Вход в аккаунт',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Нет аккаунта? ',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Создать аккаунт',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Registration()));
                            },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    focusNode: emailFocus,
                    autofocus: true,
                    onFieldSubmitted: (_) {
                      _fieldFocusChanged(context, emailFocus, passFocus);
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: const Text('Email *'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    focusNode: passFocus,
                    controller: _passController,
                    obscureText: _hidePass,
                    decoration: InputDecoration(
                      labelText: 'Пароль *',
                      hintText: 'Введите пароль',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePass ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePass = !_hidePass;
                          });
                        },
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(400, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                        ),
                      ),
                      onPressed: () {
                        _submitForm();
                        Func().getFirebaseToken();
                      },
                      child: const Text(
                        'Войти',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future login(Map<String, dynamic>? userData) async {
    final dio = Dio();
    final cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    try {
      final response = await dio.get('${Constants.API_URL_DOMAIN}action=auth&', queryParameters: {
        "email": _emailController.text,
        "password": _passController.text,
      });
      List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse(Constants.API_URL_DOMAIN));
      String cookie = cookies.map((c) => '${c.name}=${c.value}').join(';');
      if(cookie.isNotEmpty) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('cookie', cookie);
        setState(() {
          Constants.cookie = pref.getString('cookie') ?? '';
        });
      }
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<void> _submitForm() async {
    Map<String, dynamic> userData = {
      "phone": _emailController.text,
      "password": _passController.text,
    };
    dynamic response = await login(userData);
    if (response.data['api_token'] != null) {
      Func().showSnackbar(
          context, response.data['message'], response.data['success']);
      pageRoute(response.data['api_token']);
    } else {
      Func().showSnackbar(
          context, response.data['message'], response.data['success']);
    }
  }

  void pageRoute(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('login', token);
    setState(() {
      Constants.USER_TOKEN = pref.getString('login') ?? '';
      Constants.bearer = 'Bearer ${pref.getString('login') ?? ''}';
    });
    await Func().getInitParams();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
}
