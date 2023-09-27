import 'package:flutter/material.dart';

import '../../screens/main_screen.dart';

Widget bagEmptyModel(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Center(
        child: Icon(
          Icons.remove_shopping_cart,
          size: 75,
          color: Color.fromRGBO(94, 98, 120, 1),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      const Text(
        'В корзине ничего нет',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF414141),
          fontSize: 22,
          fontFamily: 'Noto Sans',
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      // ignore: prefer_const_constructors
      Text(
        'Вы можете начать покупки с \nглавной страницы',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF5B5B5B),
          fontSize: 15,
          fontFamily: 'Noto Sans',
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 40),
          ),
          onPressed: () {
            scakey.currentState?.onItemTapped(0);
          },
          child: const Text(
            'На главную страницу',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Noto Sans',
              fontWeight: FontWeight.w700,
            ),
          )
        ),
      ),
    ],
  );
}

Widget bagNonAuthModel(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Center(
        child:
        Icon(
          Icons.remove_shopping_cart,
          size: 75,
          color: Color.fromRGBO(94, 98, 120, 1),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      const Center(
        child: Text(
          'Для использования корзины\n необходимо войти в аккаунт',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF5B5B5B),
            fontSize: 17,
            fontFamily: 'Noto Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 40),
          ),
          onPressed: () {
            scakey.currentState?.onItemTapped(3);
          },
          child: const Text(
            'Войти',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Noto Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ],
  );
}
