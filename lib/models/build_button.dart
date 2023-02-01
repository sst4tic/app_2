// import 'package:flutter/material.dart';
//
// import '../util/constants.dart';
// import '../util/function_class.dart';
// import '../util/styles.dart';
//
// class BuildButton extends StatefulWidget {
//   BuildButton({
//     Key? key,
//     required this.isLoading,
//     required this.isLoaded,
//     required this.selectedIndex,
//     required this.index,
//     required this.id,
//   }) : super(key: key);
//
//   bool isLoading;
//   bool isLoaded;
//   int selectedIndex;
//   final int index;
//   final int id;
//
//   @override
//   State<BuildButton> createState() => _BuildButtonState();
// }
//
// class _BuildButtonState extends State<BuildButton> {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//         icon: widget.isLoading && widget.selectedIndex == widget.index
//             ? Container(
//                 width: 16,
//                 height: 16,
//                 padding: const EdgeInsets.all(1.0),
//                 child: const CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 3,
//                 ),
//               )
//             : Icon(
//                 widget.isLoaded && widget.selectedIndex == widget.index
//                     ? Icons.done
//                     : Icons.shopping_basket,
//                 size: 16),
//         onPressed: () {
//           setState(() {
//             widget.isLoading = true;
//             widget.selectedIndex = widget.index;
//           });
//           Func()
//               .addToBag(
//             productId: widget.id,
//             context: context,
//             onSuccess: () {
//               setState(() {
//                 widget.isLoaded = true;
//                 widget.isLoading = false;
//               });
//             },
//             onFailure: () {
//               setState(() {
//                 widget.isLoading = false;
//                 widget.isLoaded = false;
//                 Constants.USER_TOKEN == '' ? Func().onSubmit(context: context) : null;
//               });
//             },
//           )
//               .then((value) {
//             Future.delayed(const Duration(seconds: 2))
//                 .then((value) => setState(() {
//                       widget.isLoading = false;
//                       widget.isLoaded = false;
//                     }));
//           });
//         },
//         style: BagButtonStyle(
//             context: context,
//             isLoaded: widget.isLoaded,
//             selectedIndex: widget.selectedIndex,
//             index: widget.index),
//         label: Text(
//           widget.isLoaded && widget.selectedIndex == widget.index
//               ? 'Добавлен'
//               : 'В корзину',
//           style: const TextStyle(fontSize: 11),
//           textAlign: TextAlign.center,
//         ));
//   }
// }
