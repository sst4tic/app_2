import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yiwumart/screens/pass_reset_screen.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../util/function_class.dart';
import '../util/styles.dart';

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
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool passVisible = false;
  String completeNum = '';
  late StreamController<int> _events;
  int _counter = 0;

  void _fieldFocusChanged(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passFocus.dispose();
    _phoneController.dispose();
    _passController.dispose();
    _events.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _events = StreamController<int>.broadcast();
    _events.add(60);
  }

  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  void startTimer() {
    _counter = 60;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        _counter--;
        print(_counter);
        _events.add(_counter);
      }
    });
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
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Container(
                padding: REdgeInsets.symmetric(horizontal: 30, vertical: 14),
                margin: REdgeInsets.all(26),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Вход в аккаунт',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Noto Sans'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Номер телефона',
                      style: TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 12.31,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    IntlPhoneField(
                      pickerDialogStyle: PickerDialogStyle(
                        listTilePadding: const EdgeInsets.all(0),
                        searchFieldInputDecoration:
                            InputDecorations(hintText: 'Поиск')
                                .loginDecoration
                                .copyWith(
                                    prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                )),
                      ),
                      dropdownDecoration: const BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      validator: (value) {
                        if (value!.completeNumber.isEmpty) {
                          return 'Введите номер телефона';
                        }
                        return null;
                      },
                      flagsButtonPadding: REdgeInsets.only(
                        left: 5,
                        top: 0,
                        bottom: 0,
                      ),
                      flagsButtonMargin: REdgeInsets.only(
                          top: 1, bottom: 1, left: 0.5, right: 5),
                      dropdownIconPosition: IconPosition.trailing,
                      dropdownIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      dropdownTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.23,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                      disableLengthCheck: true,
                      onChanged: (phone) {
                        setState(() {
                          completeNum = phone.completeNumber;
                        });
                      },
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneInputFormatter(defaultCountryCode: 'KZ')
                      ],
                      searchText: 'Выберите страну',
                      countries: const [
                        'KZ',
                        'UZ',
                        'TJ',
                        'KG',
                      ],
                      decoration: InputDecorations(hintText: '')
                          .loginDecoration
                          .copyWith(
                              constraints: const BoxConstraints(maxHeight: 35)),
                      initialCountryCode: 'KZ',
                    ),
                    if (passVisible) ...[
                      SizedBox(height: 5.h),
                      const Text(
                        'Пароль',
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 12.31,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      TextFormField(
                        focusNode: passFocus,
                        controller: _passController,
                        obscureText: _hidePass,
                        decoration: InputDecorations(hintText: 'Введите пароль')
                            .loginDecoration
                            .copyWith(
                              contentPadding: REdgeInsets.only(
                                  bottom: 8.0, top: 8, left: 8, right: 8),
                              suffixIconConstraints:
                                  const BoxConstraints(maxHeight: 33),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hidePass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          const Spacer(),
                          RichText(
                            text: TextSpan(
                              text: 'Забыли пароль? ',
                              style: const TextStyle(
                                  fontSize: 11.46,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueAccent),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PassResetScreen()));
                                },
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: passVisible ? 8 : 24),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 40)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      onPressed: () {
                        String cleanedNumber =
                            completeNum.replaceAll(RegExp(r'[^\d+]'), '');
                        print(cleanedNumber);
                        print(_passController.text);
                        if (cleanedNumber.isEmpty) {
                          Func().showSnackbar(
                              context, 'Введите номер телефона', false);
                          return;
                        } else if (cleanedNumber.length < 12) {
                          Func().showSnackbar(context,
                              'Номер телефона должен содержать 11 цифр', false);
                          return;
                        }
                        if (passVisible) {
                          context.read<AuthBloc>().add(LoginEvent(
                              email: _phoneController.text,
                              password: _passController.text,
                              context: context));
                        } else {
                          startTimer();
                          context.read<AuthBloc>().add(LoginSmsEvent(
                              countStream: _events.stream.asBroadcastStream(),
                              phone: cleanedNumber,
                              context: context,
                              restartCallback: () {
                                startTimer();
                              }));
                        }
                        // if (_emailController.text.isEmpty ||
                        //     _passController.text.isEmpty) {
                        // Func().showSnackbar(context, 'Заполните все поля', false);
                        // }
                      },
                      child: Text(
                        passVisible ? 'Войти' : 'Получить SMS с кодом',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                            child: Divider(
                          thickness: 1,
                        )),
                        SizedBox(width: 11.w),
                        const Text(
                          'или',
                          style: TextStyle(
                            color: Color(0xFFC1C1C1),
                            fontSize: 15,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.15,
                          ),
                        ),
                        SizedBox(width: 11.w),
                        const Expanded(
                            child: Divider(
                          thickness: 1,
                        )),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 40)),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        elevation: MaterialStateProperty.all(0),
                        side: MaterialStateProperty.all(
                            const BorderSide(width: 1, color: Color.fromRGBO(73, 73, 73, 1))),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          passVisible = !passVisible;
                        });
                        // if (_emailController.text.isEmpty ||
                        //     _passController.text.isEmpty) {
                        // Func().showSnackbar(context, 'Заполните все поля', false);
                        // }
                        // Func().showSmsDialog(
                        //     context: context, submitCallback: () {});
                        // context.read<AuthBloc>().add(LoginEvent(
                        //     email: _emailController.text,
                        //     password: _passController.text,
                        //     context: context));
                      },
                      child: Text(
                        passVisible ? 'Войти с SMS кодом' : 'Войти с паролем',
                        style: TextStyle(
                          color: Color.fromRGBO(73, 73, 73, 1),
                          fontSize: 14,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///: OLD VERSION !
// Center(
// child: SingleChildScrollView(
// physics: const BouncingScrollPhysics(),
// child: Padding(
// padding: EdgeInsets.symmetric(
// vertical: MediaQuery.of(context).size.height * 0.01,
// horizontal: MediaQuery.of(context).size.width * 0.05),
// child: Form(
// key: _formKey,
// child: Container(
// margin: REdgeInsets.symmetric(horizontal: 20, vertical: 20),
// child: Material(
// borderRadius: BorderRadius.circular(20),
// elevation: 3,
// child: Container(
// padding: REdgeInsets.all(8),
// width: double.infinity,
// decoration: BoxDecoration(
// color: Theme.of(context).colorScheme.secondary,
// borderRadius: const BorderRadius.all(
// Radius.circular(20),
// ),
// ),
// child: Column(
// mainAxisSize: MainAxisSize.max,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// const Text(
// 'Вход в аккаунт',
// style: TextStyle(
// fontSize: 20, fontWeight: FontWeight.w500),
// ),
// const SizedBox(height: 5),
// Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// const Text(
// 'Нет аккаунта? ',
// style:
// TextStyle(fontSize: 16, color: Colors.grey),
// ),
// RichText(
// text: TextSpan(
// text: 'Создать аккаунт',
// style: const TextStyle(
// fontSize: 16, color: Colors.red),
// recognizer: TapGestureRecognizer()
// ..onTap = () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// const Registration()));
// },
// ),
// ),
// ],
// ),
// const SizedBox(
// height: 30,
// ),
// const SizedBox(height: 20),
// TextFormField(
// focusNode: emailFocus,
// keyboardType: TextInputType.emailAddress,
// autofocus: true,
// onFieldSubmitted: (_) {
// _fieldFocusChanged(context, emailFocus, passFocus);
// },
// controller: _emailController,
// decoration: InputDecoration(
// label: const Text('Email *'),
// floatingLabelBehavior: FloatingLabelBehavior.always,
// labelStyle: const TextStyle(color: Colors.grey),
// errorBorder: OutlineInputBorder(
// borderSide:
// const BorderSide(color: Colors.red, width: 1),
// borderRadius: BorderRadius.circular(18),
// ),
// ),
// ),
// const SizedBox(height: 20),
// TextFormField(
// focusNode: passFocus,
// controller: _passController,
// obscureText: _hidePass,
// decoration: InputDecoration(
// labelText: 'Пароль *',
// hintText: 'Введите пароль',
// floatingLabelBehavior: FloatingLabelBehavior.always,
// labelStyle: const TextStyle(color: Colors.grey),
// suffixIcon: IconButton(
// icon: Icon(
// _hidePass
// ? Icons.visibility
//     : Icons.visibility_off,
// ),
// onPressed: () {
// setState(() {
// _hidePass = !_hidePass;
// });
// },
// color: Colors.grey,
// ),
// ),
// ),
// const SizedBox(height: 20),
// Expanded(
// flex: 0,
// child: ElevatedButton(
// style: ButtonStyle(
// minimumSize: MaterialStateProperty.all(
// const Size(double.infinity, 40)),
// shape: MaterialStateProperty.all<
// RoundedRectangleBorder>(
// RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10.0)),
// ),
// ),
// onPressed: () {
// context.read<AuthBloc>().add(LoginEvent(
// email: _emailController.text,
// password: _passController.text,
// context: context));
// },
// child: const Text(
// 'Войти',
// style: TextStyle(fontSize: 18),
// ),
// ),
// ),
// SizedBox(
// height: 5.h,),
// RichText(
// text: TextSpan(
// text: 'Забыли пароль? ',
// style: const TextStyle(
// fontSize: 16, color: Colors.blueAccent),
// recognizer: TapGestureRecognizer()
// ..onTap = () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// const PassResetScreen()));
// },
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ),
// ),
// ),
// ),
