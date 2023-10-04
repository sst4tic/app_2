import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yiwumart/models/status_progress_model.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper({Key? key, required this.data}) : super(key: key);
  final List<StatusProgressModel> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Stack(
            children: [
              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 5,
                  ),
                  height: index == data.length - 1 ? 20 : 80,
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: item.enabled
                          ? const Color.fromRGBO(53, 138, 67, 1)
                          : const Color.fromRGBO(127, 127, 127, 1),
                      width: 0.5,
                    ),
                  )),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/${item.enabled ? 'enabled_${index + 1}' : 'disabled_${index + 1}'}.svg',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Заказ отправлен',
                    style: TextStyle(
                      color: Color(0xFF181C32),
                      fontSize: 12,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '28.10.2023',
                    style: TextStyle(
                      color: Color(0xFF919191),
                      fontSize: 10,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

// Stack(
// children: [
// Positioned(
// child: Container(
// margin: EdgeInsets.only(left: 4, right: 5, top:
// index == data.length - 1 ?
// 0 : 20,
// ),
// height:
// index == data.length - 1 ? 0 :
// 100,
// width: 1,
// decoration: const BoxDecoration(
// border: Border(
// left: BorderSide(
// color: Colors.red,
// width: 1,
// ),
// )),
// ),
// ),
// Row(
// children: [
// Container(
// height: 9,
// width: 9,
// decoration: const BoxDecoration(
// color: Colors.red,
// shape: BoxShape.circle,
// ),
// ),
// const SizedBox(width: 10),
// SvgPicture.asset(
// 'assets/icons/bag_error.svg',
// height: 40,
// width: 40,
// ),
// const SizedBox(width: 10),
// const Text(
// 'Заказ отправлен',
// style: TextStyle(
// color: Color(0xFF181C32),
// fontSize: 12,
// fontFamily: 'Noto Sans',
// fontWeight: FontWeight.w400,
// ),
// ),
// const Spacer(),
// const Text(
// '28.10.2023',
// style: TextStyle(
// color: Color(0xFF919191),
// fontSize: 10,
// fontFamily: 'Noto Sans',
// fontWeight: FontWeight.w500,
// ),
// ),
// ],
// ),
// ],
// );
