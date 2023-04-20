import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                _phoneController.text = state.user.phone!.substring(2);
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
        child: ListView(
          padding: REdgeInsets.all(8),
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
                  const Text('Параметры доставки',
                      style: TextStyle(fontSize: 14)),
                  const Divider(),
                  Text('Получатель'.toUpperCase(),
                      style: TextStyles.headerStyle2),
                  SizedBox(height: 8.h),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: user.fullName,
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text('Номер телефона *'.toUpperCase(),
                      style: TextStyles.headerStyle2),
                  SizedBox(height: 8.h),
                  IntlPhoneField(
                    controller: _phoneController,
                    dropdownIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    searchText: 'Выберите страну',
                    countries: const [
                      'KZ',
                    ],
                    initialCountryCode: 'KZ',
                  ),
                  Text('Адрес доставки *'.toUpperCase(),
                      style: TextStyles.headerStyle2),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: 'Введите адрес: город, улица, дом, квартира',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.center,
                    minLines: 3,
                    maxLines: null,
                  ),
                  const Divider(),
                  Text('Способ оплаты'.toUpperCase(),
                      style: TextStyles.headerStyle2),
                  SizedBox(height: 8.h),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: 'Онлайн оплата временно недоступна',
                      hintStyle: TextStyles.headerStyle2
                          .copyWith(color: Colors.grey, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                      'После оформления заказа с вами свяжется наш специалист для уточнения деталей заказа.',
                      style: TextStyles.headerStyle2),
                  const Divider(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text('Итоговая сумма: $totalSum тг',
                        style: const TextStyle(fontSize: 14)),
                  ),
                  const Divider(),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _purchaseBloc.add(PurchaseCheckout(
                            context: context,
                            cartId: widget.cartId,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            comments: _commentController.text));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Заполните все поля')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 30.h),
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Оформить заказ',
                      style: TextStyle(
                        fontSize: 14,
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
