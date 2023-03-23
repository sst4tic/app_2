import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/screens/profile_screen.dart';
import '../util/constants.dart';
import '../util/function_class.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final _formKey = GlobalKey<FormState>();
  bool _hidePass = true;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        key: _scaffoldkey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text(
            'Регистрация',
          ),
        ),
        body:
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01,
                  horizontal: MediaQuery
                      .of(context)
                      .size
                      .width * 0.05),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Создание аккаунта',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Уже есть аккаунт? ',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Войти',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.red),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                label: const Text('Имя'),
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always,
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
                              // inputFormatters: [
                              //   LengthLimitingTextInputFormatter(10)
                              // ],
                              // validator: _validateName
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _surnameController,
                              decoration: InputDecoration(
                                label: const Text('Фамилия'),
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
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
                            borderSide: const BorderSide(
                                color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePass ? Icons.visibility : Icons
                                  .visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _hidePass = !_hidePass;
                              });
                            },
                            color: Colors.grey,
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(

                        controller: _confirmPassController,
                        obscureText: _hidePass,
                        decoration: InputDecoration(
                          labelText: 'Повторите пароль *',
                          hintText: 'Повторите пароль',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(width: 1)),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(400, 50)),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                            ),
                          ),
                          onPressed: () {
                            if (_passController.text ==
                                _confirmPassController.text) {
                              _submitForm();
                              Func().getFirebaseToken();
                            } else {
                              Func().showSnackbar(
                                  context, 'Пароли не совпадают', false);
                            }
                          },
                          child: const Text(
                            'Продолжить',
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
        ),
      );
  }

  Future registerUser(Map<String, dynamic>? userData) async {
    final Dio dio = Dio();
    try {
      Response response = await dio.get(
          '${Constants.API_URL_DOMAIN}action=register&',
          queryParameters: {
            "email": _emailController.text,
            "password": _passController.text,
            "name": _nameController.text,
            "surname": _surnameController.text
          });
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<void> _submitForm() async {
    Map<String, dynamic> userData = {
      "email": _emailController.text,
      "password": _passController.text,
      "name": _nameController.text,
      "surname": _surnameController.text,
    };
    _validatePassword;
    dynamic response = await registerUser(userData);
    if (response.data['api_token'] != null) {
      Func().showSnackbar(
          context, response.data['message'], response.data['success']);
      pageRoute(response.data['api_token']);
    } else {
      Func().showSnackbar(
          context, response.data['message'], response.data['success']);
    }
  }

  String? _validatePassword(String? value) {
    if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  void pageRoute(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('login', token);
    setState(() {
      Constants.USER_TOKEN = pref.getString('login') ?? '';
      Constants.bearer = 'Bearer ${pref.getString('login') ?? ''}';
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }
}


