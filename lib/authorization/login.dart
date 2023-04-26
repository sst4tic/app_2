import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/authorization/registration.dart';
import 'package:yiwumart/screens/pass_reset_screen.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

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
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Form(
              key: _formKey,
              child: Container(
                margin: REdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 3,
                  child: Container(
                    padding: REdgeInsets.all(8),
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
                      children: [
                        const Text(
                          'Вход в аккаунт',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Нет аккаунта? ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Создать аккаунт',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.red),
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
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          onFieldSubmitted: (_) {
                            _fieldFocusChanged(context, emailFocus, passFocus);
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                            label: const Text('Email *'),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: const TextStyle(color: Colors.grey),
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
                            labelStyle: const TextStyle(color: Colors.grey),
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
                        const SizedBox(height: 20),
                        Expanded(
                          flex: 0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 40)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(LoginEvent(
                                  email: _emailController.text,
                                  password: _passController.text,
                                  context: context));
                            },
                            child: const Text(
                              'Войти',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,),
                        RichText(
                          text: TextSpan(
                            text: 'Забыли пароль? ',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blueAccent),
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
