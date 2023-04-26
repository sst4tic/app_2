import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/function_class.dart';

class PassUpdateScreen extends StatefulWidget {
  const PassUpdateScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<PassUpdateScreen> createState() => _PassUpdateScreenState();
}

class _PassUpdateScreenState extends State<PassUpdateScreen> {
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _hidePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Обновление пароля'),
      ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: _passController,
                    obscureText: _hidePass,
                    decoration: InputDecoration(
                      labelText: 'Пароль *',
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
                      labelText: 'Повторите пароль',
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
                        var resp = await Func().updatePassAfterReset(
                            widget.email, _passController.text);
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
                        if (resp['success']) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          });
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
    );
  }
}
