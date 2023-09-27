import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../util/function_class.dart';
import '../util/styles.dart';

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
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'Регистрация',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Container(
                padding: REdgeInsets.all(16),
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
                        'Создание аккаунта',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Noto Sans'),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Text(
                      'ФИО',
                      style: TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 12.31,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecorations(hintText: 'Введите имя')
                          .loginDecoration,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    ),
                    SizedBox(height: 5.h),
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
                      dropdownDecoration: const BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      flagsButtonPadding:
                          REdgeInsets.only(left: 5, top: 0, bottom: 0),
                      flagsButtonMargin:
                          REdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
                      dropdownIconPosition: IconPosition.trailing,
                      dropdownIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      disableLengthCheck: true,
                      onChanged: (phone) {
                        // setState(() {
                        //   completeNum = phone.completeNumber;
                        // });
                      },
                      // controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      // ),
                      searchText: 'Выберите страну',
                      countries: const [
                        'KZ',
                        'UZ',
                        'TJ',
                        'KG',
                      ],
                      decoration: InputDecorations(hintText: '')
                          .loginDecoration
                          .copyWith(constraints: const BoxConstraints(maxHeight: 35)),
                      initialCountryCode: 'KZ',
                    ),
                    // TextFormField(
                    //   controller: _emailController,
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration:
                    //       InputDecorations(hintText: '').loginDecoration,
                    // ),
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
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 5.h),
                    const Text(
                      'Повторите пароль',
                      style: TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 12.31,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    TextFormField(
                      controller: _confirmPassController,
                      obscureText: _hidePass,
                      decoration: InputDecorations(hintText: 'Повторите пароль')
                          .loginDecoration,
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      flex: 0,
                      child: ElevatedButton(
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
                          if (_passController.text ==
                              _confirmPassController.text) {
                            context.read<AuthBloc>().add(RegistrationEvent(
                                email: _emailController.text,
                                password: _passController.text,
                                name: _nameController.text,
                                surname: _surnameController.text,
                                context: context));
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
                    SizedBox(height: 10.h),
                    Center(
                      child:Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Уже есть аккаунт?',
                              style: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 12.31,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              text: ' Войти',
                              style: const TextStyle(
                                color: Color(0xFF0D6EFD),
                                fontSize: 12.31,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
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

  String? _validatePassword(String? value) {
    if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }
}

//: OLD VERSION!
// Center(
// child: SingleChildScrollView(
// physics: const BouncingScrollPhysics(),
// child: SafeArea(
// child: Form(
// key: _formKey,
// child: Container(
// padding: REdgeInsets.all(16),
// margin: REdgeInsets.all(26),
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
// 'Создание аккаунта',
// style:
// TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
// ),
// const SizedBox(
// height: 30,
// ),
// Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Expanded(
// child: TextFormField(
// controller: _nameController,
// decoration: const InputDecoration(
// label: Text('Имя'),
// floatingLabelBehavior:
// FloatingLabelBehavior.always,
// ),
// inputFormatters: [
// LengthLimitingTextInputFormatter(10)
// ],
// ),
// ),
// const SizedBox(width: 12),
// Expanded(
// child: TextFormField(
// controller: _surnameController,
// decoration: const InputDecoration(
// label: Text('Фамилия'),
// floatingLabelBehavior:
// FloatingLabelBehavior.always,
// ),
// ),
// ),
// ],
// ),
// const SizedBox(height: 20),
// TextFormField(
// controller: _emailController,
// keyboardType: TextInputType.emailAddress,
// decoration: const InputDecoration(
// label: Text('Email *'),
// floatingLabelBehavior: FloatingLabelBehavior.always,
// ),
// ),
// const SizedBox(height: 20),
// TextFormField(
// controller: _passController,
// obscureText: _hidePass,
// decoration: InputDecoration(
// labelText: 'Пароль *',
// hintText: 'Введите пароль',
// floatingLabelBehavior: FloatingLabelBehavior.always,
// suffixIcon: IconButton(
// icon: Icon(
// _hidePass ? Icons.visibility : Icons.visibility_off,
// ),
// onPressed: () {
// setState(() {
// _hidePass = !_hidePass;
// });
// },
// color: Colors.grey,
// ),
// ),
// validator: _validatePassword,
// ),
// const SizedBox(
// height: 20,
// ),
// TextFormField(
// controller: _confirmPassController,
// obscureText: _hidePass,
// decoration: const InputDecoration(
// labelText: 'Повторите пароль *',
// hintText: 'Повторите пароль',
// floatingLabelBehavior: FloatingLabelBehavior.always,
// ),
// validator: _validatePassword,
// ),
// const SizedBox(height: 20),
// Expanded(
// flex: 0,
// child: ElevatedButton(
// style: ButtonStyle(
// minimumSize: MaterialStateProperty.all(
// const Size(double.infinity, 40)),
// shape:
// MaterialStateProperty.all<RoundedRectangleBorder>(
// RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10.0)),
// ),
// ),
// onPressed: () {
// if (_passController.text ==
// _confirmPassController.text) {
// context.read<AuthBloc>().add(RegistrationEvent(
// email: _emailController.text,
// password: _passController.text,
// name: _nameController.text,
// surname: _surnameController.text,
// context: context));
// } else {
// Func().showSnackbar(
// context, 'Пароли не совпадают', false);
// }
// },
// child: const Text(
// 'Продолжить',
// style: TextStyle(fontSize: 18),
// ),
// ),
// ),
// Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// const Text(
// 'Уже есть аккаунт? ',
// style: TextStyle(fontSize: 16, color: Colors.grey),
// ),
// RichText(
// text: TextSpan(
// text: 'Войти',
// style: const TextStyle(
// fontSize: 16, color: Colors.red),
// recognizer: TapGestureRecognizer()
// ..onTap = () {
// setState(() {
// Navigator.pop(context);
// });
// },
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// ),
// ),
// ),
