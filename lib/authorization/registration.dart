import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
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
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: SafeArea(
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
                          const SizedBox(height: 30),
                          const Text(
                            'Создание аккаунта',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Уже есть аккаунт? ',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Войти',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.red),
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
                                  decoration: const InputDecoration(
                                    label: Text('Имя'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _surnameController,
                                  decoration: const InputDecoration(
                                    label: Text('Фамилия'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              label: Text('Email *'),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passController,
                            obscureText: _hidePass,
                            decoration: InputDecoration(
                              labelText: 'Пароль *',
                              hintText: 'Введите пароль',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _confirmPassController,
                            obscureText: _hidePass,
                            decoration: const InputDecoration(
                              labelText: 'Повторите пароль *',
                              hintText: 'Повторите пароль',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            validator: _validatePassword,
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                              onPressed: () {
                                if (_passController.text ==
                                    _confirmPassController.text) {
                                  context.read<AuthBloc>().add(
                                      RegistrationEvent(
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
                        ],
                      ),
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

  String? _validatePassword(String? value) {
    if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }
}
