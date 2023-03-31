import 'package:flutter/material.dart';

import '../../screens/main_screen.dart';

  Widget bagEmptyModel(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.remove_shopping_cart_outlined,
            size: 50,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Ваша корзина пуста',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget bagNonAuthModel(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.remove_shopping_cart_outlined,
            size: 50,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Для использования корзины\n необходимо войти в аккаунт',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              scakey.currentState?.onItemTapped(3);
            },
            child: const Text(
              'Войти в аккаунт',
            ),
          ),
        ),
      ],
    );
  }
