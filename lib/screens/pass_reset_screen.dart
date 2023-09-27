import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yiwumart/screens/code_entry_screen.dart';
import 'package:yiwumart/util/function_class.dart';

import '../util/styles.dart';

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
        title: const Text('Восстановление пароля'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50.h),
          SvgPicture.asset(
            'assets/img/logo.svg',
            height: 28.h,
          ),
          Container(
            padding: REdgeInsets.all(16),
            margin: REdgeInsets.all(26),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Восстановление пароля',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.48,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                const Text(
                  'Номер телефона ',
                  style: TextStyle(
                    color: Color(0xFF494949),
                    fontSize: 12.31,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                IntlPhoneField(
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
                  // onChanged: (phone) {
                  //   setState(() {
                  //     completeNum = phone.completeNumber;
                  //   });
                  // },
                  // controller: _phoneController,
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
                SizedBox(height: 10.h),
                Expanded(
                  flex: 0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 40)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    onPressed: () async {
                      var resp =
                          await Func().resetPassword(_emailController.text);
                      if (resp['success']) {
                        Func().showSnackbar(
                            context, resp['message'], resp['success']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CodeEntryScreen(
                                      email: _emailController.text,
                                    )));
                      } else {
                        Func().showSnackbar(
                            context, resp['message'], resp['success']);
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
        ],
      ),
    );
  }
}
