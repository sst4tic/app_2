import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/screens/code_entry_screen.dart';
import 'package:yiwumart/util/function_class.dart';


class PassResetScreen extends StatefulWidget {
  const PassResetScreen({Key? key}) : super(key: key);

  @override
  State<PassResetScreen> createState() => _PassResetScreenState();
}

class _PassResetScreenState extends State<PassResetScreen> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановить пароль'),
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
                    'Восстановление пароля',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    autofocus: true,
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
                      hintText: 'Введите email',
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                      onPressed: () async {
                        var resp = await Func().resetPassword(_emailController.text);
                        if (resp['success']) {
                          Func().showSnackbar(context, resp['message'], resp['success']);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CodeEntryScreen(email: _emailController.text,)));
                        } else {
                          Func().showSnackbar(context, resp['message'], resp['success']);
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
