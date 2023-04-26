import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/function_class.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({Key? key}) : super(key: key);

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final _currentPassController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _hidePass = true;
  bool _hideCurrentPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
              horizontal: MediaQuery.of(context).size.width * 0.05),
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Обновите пароль',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: _currentPassController,
                    obscureText: _hideCurrentPass,
                    decoration: InputDecoration(
                      labelText: 'Текущий пароль *',
                      hintText: 'Введите текущий пароль',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideCurrentPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hideCurrentPass = !_hideCurrentPass;
                          });
                        },
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  TextFormField(
                    controller: _passController,
                    obscureText: _hidePass,
                    decoration: InputDecoration(
                      labelText: 'Новый пароль *',
                      hintText: 'Введите пароль',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  SizedBox(height: 15.h),
                  TextFormField(
                    controller: _confirmPassController,
                    obscureText: _hidePass,
                    decoration: const InputDecoration(
                      labelText: 'Повторите пароль *',
                      hintText: 'Повторите пароль',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                      onPressed: () async {
                        var resp = await Func().changePassword(
                            pass: _currentPassController.text,
                            newPass: _passController.text);
                        // ignore: use_build_context_synchronously
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text(resp['message']),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ок'),
                              ),
                            ],
                          ),
                        );
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
    );
  }
}
