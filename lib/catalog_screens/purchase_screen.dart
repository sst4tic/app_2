import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/edit_repo.dart';
import 'package:yiwumart/bloc/purchase_bloc/purchase_bloc.dart';
import '../models/shimmer_model.dart';
import '../util/styles.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key, required this.cartId, required this.totalSum})
      : super(key: key);
  final int cartId;
  final String totalSum;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _purchaseBloc = PurchaseBloc(editProfileRepo: EditRepo());
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedOption = 0;

  @override
  void initState() {
    super.initState();
    _purchaseBloc
        .add(LoadPurchase(id: widget.cartId, totalSum: widget.totalSum));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Оформление заказа',
          ),
          centerTitle: false,
        ),
        body: BlocProvider(
          create: (context) => PurchaseBloc(editProfileRepo: EditRepo()),
          child: BlocBuilder<PurchaseBloc, PurchaseState>(
            bloc: _purchaseBloc,
            builder: (context, state) {
              if (state is PurchaseLoading) {
                return buildPurchaseShimmer(context);
              } else if (state is PurchaseLoaded) {
                _phoneController.text = state.user.phone != null
                    ? state.user.phone!.substring(2)
                    : '';
                return buildPurchase(
                    totalSum: state.totalSum, user: state.user);
              } else if (state is PurchaseError) {
                return Text(state.error.toString());
              } else {
                return buildPurchaseShimmer(context);
              }
            },
          ),
        ));
  }

  Widget buildPurchase({required String totalSum, required user}) => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: REdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: REdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Получатель'.toUpperCase(),
                        style: TextStyles.headerStyle2),
                    SizedBox(height: 8.h),
                    TextFormField(
                      enabled: false,
                      decoration: InputDecorations(hintText: user.fullName)
                          .editDecoration,
                    ),
                    SizedBox(height: 8.h),
                    Text('Номер телефона *'.toUpperCase(),
                        style: TextStyles.headerStyle2),
                    SizedBox(height: 8.h),
                    IntlPhoneField(
                      pickerDialogStyle: PickerDialogStyle(
                        listTilePadding: const EdgeInsets.all(0),
                        searchFieldInputDecoration:
                            InputDecorations(hintText: 'Поиск')
                                .loginDecoration
                                .copyWith(
                                    prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                )),
                      ),
                      dropdownDecoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      validator: (value) {
                        if (value!.completeNumber.isEmpty) {
                          return 'Введите номер телефона';
                        }
                        return null;
                      },
                      flagsButtonPadding: REdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
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
                      decoration: InputDecorations(hintText: '').editDecoration,
                      initialCountryCode: 'KZ',
                      enabled: false,
                    ),
                    SizedBox(height: 8.h),
                    Text('Адрес доставки *'.toUpperCase(),
                        style: TextStyles.headerStyle2),
                    SizedBox(height: 8.h),
                    TextFormField(
                        controller: _addressController,
                        decoration: InputDecorations(
                                hintText:
                                    'Введите адрес: город, улица, дом, кв')
                            .editDecoration),
                    SizedBox(height: 8.h),
                    Text('Комментарий к заказу'.toUpperCase(),
                        style: TextStyles.headerStyle2),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        contentPadding:
                            REdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        hintText: 'Введите комментарий',
                        hintStyle: const TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 14,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D6EFD),
                            width: 0.5,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.center,
                      minLines: 3,
                      maxLines: null,
                    ),
                    const Divider(
                      height: 24,
                    ),
                    Text('Способ оплаты'.toUpperCase(),
                        style: TextStyles.headerStyle2),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = 0;
                              });
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: REdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: selectedOption == 0
                                            ? const Color.fromRGBO(
                                                240, 246, 255, 1)
                                            : Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: selectedOption == 0
                                              ? Colors.blue
                                              : const Color.fromRGBO(
                                                  218, 218, 218, 1),
                                          width: 1,
                                        ),
                                      ),
                                      width: 44,
                                      height: 44,
                                      child: SvgPicture.asset(
                                        'assets/icons/card_icon.svg',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Онлайн оплата',
                                      style: TextStyle(
                                        color: Color(0xFF626262),
                                        fontSize: 10,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                selectedOption == 0
                                    ? Positioned(
                                        right: 0,
                                        top: -5,
                                        left: 40,
                                        child: SvgPicture.asset(
                                          'assets/icons/check_icon.svg',
                                        ))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = 1;
                              });
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: REdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: selectedOption == 1
                                            ? const Color.fromRGBO(
                                                240, 246, 255, 1)
                                            : Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: selectedOption == 1
                                              ? Colors.blue
                                              : const Color.fromRGBO(
                                                  218, 218, 218, 1),
                                          width: 1,
                                        ),
                                      ),
                                      width: 44,
                                      height: 44,
                                      child: SvgPicture.asset(
                                        'assets/icons/cash_icon.svg',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Наличными',
                                      style: TextStyle(
                                        color: Color(0xFF626262),
                                        fontSize: 10,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                selectedOption == 1
                                    ? Positioned(
                                        right: 0,
                                        top: -5,
                                        left: 40,
                                        child: SvgPicture.asset(
                                          'assets/icons/check_icon.svg',
                                        ))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = 2;
                              });
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: REdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: selectedOption == 2
                                            ? const Color.fromRGBO(
                                                240, 246, 255, 1)
                                            : Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: selectedOption == 2
                                              ? Colors.blue
                                              : const Color.fromRGBO(
                                                  218, 218, 218, 1),
                                          width: 1,
                                        ),
                                      ),
                                      width: 44,
                                      height: 44,
                                      child: SvgPicture.asset(
                                        'assets/icons/percent_icon.svg',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Кредит/Рассрочка',
                                      style: TextStyle(
                                        color: Color(0xFF626262),
                                        fontSize: 10,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                selectedOption == 2
                                    ? Positioned(
                                        right: 0,
                                        top: -5,
                                        left: 40,
                                        child: SvgPicture.asset(
                                          'assets/icons/check_icon.svg',
                                        ))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 14),
                            children: [
                              const TextSpan(
                                text: 'Итоговая сумма: ',
                                style: TextStyle(
                                  color: Color(0xFF464646),
                                  fontSize: 15,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: '$totalSum ₸',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    final payment = selectedOption == 0
                        ? 'online'
                        : selectedOption == 1
                            ? 'cash'
                            : 'credit';
                    if (_formKey.currentState!.validate()) {
                      _purchaseBloc.add(PurchaseCheckout(
                          name: user.fullName,
                          paymentMethod: payment,
                          online: payment == 'online' ? 'halyk' : null,
                          context: context,
                          cartId: widget.cartId,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          comments: _commentController.text));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Заполните все поля')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 45.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Оформить заказ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ],
          ),
        ),
      );
}
