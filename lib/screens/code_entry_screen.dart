import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/screens/pass_update_screen.dart';
import 'package:yiwumart/util/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../util/function_class.dart';

class CodeEntryScreen extends StatefulWidget {
  const CodeEntryScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<CodeEntryScreen> createState() => _CodeEntryScreenState();
}

class _CodeEntryScreenState extends State<CodeEntryScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.h),
        child: Column(
          children: [
            Text(
              'Введите код',
              style: TextStyles.headerStyle,
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              'Код подтверждения отправлен на почту'.toUpperCase(),
              style: TextStyles.editStyle,
            ),
            SizedBox(
              height: 8.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: REdgeInsets.all(16),
              padding: REdgeInsets.only(left: 16, right: 16, top: 12),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                controller: _codeController,
                animationType: AnimationType.fade,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  fieldOuterPadding: EdgeInsets.zero,
                  shape: PinCodeFieldShape.box,
                  inactiveColor: Colors.grey,
                  activeColor: Colors.grey,
                  selectedColor: Colors.grey[200]!,
                  borderRadius: BorderRadius.circular(8),
                ),
                onCompleted: (value) async {
                  var resp = await Func()
                      .validateReset(_codeController.text, widget.email);
                  if (resp['success']) {
                    Func().showSnackbar(
                        context, resp['message'], resp['success']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PassUpdateScreen(
                                  email: widget.email,
                                )));
                  }
                  Func()
                      .showSnackbar(context, resp['message'], resp['success']);
                },
                onChanged: (String value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
