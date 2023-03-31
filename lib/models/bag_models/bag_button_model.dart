import 'package:flutter/material.dart';
import '../../util/function_class.dart';
import '../../util/styles.dart';

class BagButton extends StatefulWidget {
  final int index;
  final int id;

  const BagButton({super.key, required this.index, required this.id});

  @override
  BagButtonState createState() => BagButtonState();
}

class BagButtonState extends State<BagButton> {
  bool _isLoading = false;
  bool _isLoaded = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: _isLoading && selectedIndex == widget.index
          ? Container(
        width: 16,
        height: 16,
        padding: const EdgeInsets.all(1.0),
        child: const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      )
          : Icon(
          _isLoaded && selectedIndex == widget.index
              ? Icons.done
              : Icons.shopping_basket,
          size: 16),
      onPressed: () {
        setState(() {
          _isLoading = true;
          selectedIndex = widget.index;
        });
        Func()
            .addToBag(
          productId: widget.id,
          context: context,
          onSuccess: () {
            setState(() {
              _isLoaded = true;
              _isLoading = false;
            });
          },
          onFailure: () {
            setState(() {
              _isLoading = false;
              _isLoaded = false;
            });
          },
        )
            .then((value) {
          Future.delayed(const Duration(seconds: 2))
              .then((value) => setState(() {
            _isLoading = false;
            _isLoaded = false;
          }));
        });
      },
      style: BagButtonStyle(
          context: context,
          isLoaded: _isLoaded,
          selectedIndex: selectedIndex,
          index: widget.index),
      label: Text(
        _isLoaded && selectedIndex == widget.index ? 'Добавлен' : 'В корзину',
        style: const TextStyle(fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}
