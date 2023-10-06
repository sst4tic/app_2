import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yiwumart/models/custom_stepper.dart';
import 'package:yiwumart/models/status_progress_model.dart';
import '../catalog_screens/product_screen.dart';
import '../util/order_detail.dart';
import '../util/styles.dart';

Widget buildOrderDetails({required OrderDetail details, context}) {
  final cartList = details.items;
  final images = Image.network(
    'https://picsum.photos/250?image=9',
  );
  return ListView(
    children: [
      Container(
        padding: REdgeInsets.all(10),
        margin: REdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              details.title,
              style: const TextStyle(
                color: Color(0xFF181C32),
                fontSize: 15,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              details.date,
              style: const TextStyle(
                color: Color(0xFF919191),
                fontSize: 10,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(),
            ListView.separated(
              itemCount: cartList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final cartItem = cartList[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(id: cartItem.id,)
                        ),
                      );
                    },
                    child: ListTile(
                        contentPadding: REdgeInsets.all(0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            cartItem.imageThumb,
                            width: 43,
                            height: 43,
                          ),
                        ),
                        title: Text(
                          cartItem.title.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF181C32),
                            fontSize: 12,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Text(
                          '${cartItem.price} ₸',
                          style: const TextStyle(
                            color: Color(0xFF282E4D),
                            fontSize: 15,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        )));
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 0,
                  thickness: 1,
                );
              },
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Итоговая сумма: ',
                      style: TextStyle(
                        color: Color(0xFF464646),
                        fontSize: 12,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '${details.total} ₸',
                      style: const TextStyle(
                        color: Color(0xFF282E4D),
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        padding: REdgeInsets.all(10),
        margin: REdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статус заказа',
              style: TextStyle(
                color: Color(0xFF181C32),
                fontSize: 16,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            CustomStepper(
              data: [
                StatusProgressModel(
                    statusName: 'statysName',
                    enabled: true,
                    date: '05/11/2002'),
                StatusProgressModel(
                    statusName: 'statysName',
                    enabled: true,
                    date: '05/11/2002'),
                StatusProgressModel(
                    enabled: false,
                    statusName: 'statysName',
                    date: '05/11/2002'),
                StatusProgressModel(
                    enabled: false,
                    statusName: 'statysName',
                    date: '05/11/2002'),
              ],
            ),
            // ...List.generate(4, (index) {
            //   return Row(children: [
            //     SvgPicture.asset(
            //       'assets/icons/bag_error.svg',
            //       width: 16.w,
            //       height: 16.h,
            //     ),
            //   ],);
            // }),

            // CustomStepper(
            //   data: [
            //     StatusProgressModel(
            //         img: 'Заказ оформлен',
            //         statusName: 'statysName',
            //         date: '05/11/2002'),
            //     StatusProgressModel(
            //         img: 'Заказ отправлен',
            //         statusName: 'statysName',
            //         date: '05/11/2002'),
            //     StatusProgressModel(
            //         img: 'Заказ доставлен',
            //         statusName: 'statysName',
            //         date: '05/11/2002'),
            //     StatusProgressModel(
            //         img: 'Заказ успешно выполнен',
            //         statusName: 'statysName',
            //         date: '05/11/2002'),
            //   ],
            // ),
          ],
        ),
      ),
      Container(
        padding: REdgeInsets.all(10),
        margin: REdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Данные заказа',
              style: TextStyle(
                color: Color(0xFF181C32),
                fontSize: 16,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text('Получатель'.toUpperCase(), style: TextStyles.headerStyle2),
            SizedBox(height: 8.h),
            TextFormField(
              enabled: false,
              decoration: InputDecorations(hintText: '').editDecoration,
            ),
            SizedBox(height: 8.h),
            Text('Номер телефона *'.toUpperCase(),
                style: TextStyles.headerStyle2),
            SizedBox(height: 8.h),
            IntlPhoneField(
              pickerDialogStyle: PickerDialogStyle(
                listTilePadding: const EdgeInsets.all(0),
                searchFieldInputDecoration: InputDecorations(hintText: 'Поиск')
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
              flagsButtonMargin:
                  REdgeInsets.only(top: 1, bottom: 1, left: 0.5, right: 5),
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
              keyboardType: TextInputType.phone,
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
                decoration: InputDecorations(
                        hintText: 'Введите адрес: город, улица, дом, кв')
                    .editDecoration),
            SizedBox(height: 8.h),
            Text('Комментарий к заказу'.toUpperCase(),
                style: TextStyles.headerStyle2),
            SizedBox(height: 8.h),
            TextField(
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
            const Divider(),
            Text('Способ оплаты'.toUpperCase(), style: TextStyles.headerStyle2),
            const SizedBox(height: 8),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: REdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(240, 246, 255, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    width: 44,
                    height: 44,
                    child: SvgPicture.asset(
                      'assets/icons/card_icon.svg',
                    ),
                  ),
                  Positioned(
                      top: -5,
                      right: -10,
                      child: SvgPicture.asset(
                        'assets/icons/check_icon.svg',
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    ],
  );
}
