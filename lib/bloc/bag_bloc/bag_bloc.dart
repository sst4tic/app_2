import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:yiwumart/util/cart_list.dart';
import '../../util/constants.dart';
import '../../util/function_class.dart';
import 'abstract_bag.dart';

part 'bag_event.dart';

part 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  final AbstractBag bagRepo;

  BagBloc({required this.bagRepo}) : super(BagInitial()) {
    on<LoadBag>((event, emit) async {
      try {
        if (state is! BagLoading) {
          emit(BagLoading());
          final isAuthorized = Constants.USER_TOKEN.isNotEmpty;
          if (!isAuthorized) {
            emit(BagNotAuthorized());
          } else {
            final bagList = await bagRepo.getBagList();
            if (bagList.items.isNotEmpty) {
              emit(BagLoaded(cart: bagList));
            } else {
              emit(BagEmpty());
            }
          }
        }
      } catch (e) {
        emit(BagLoadingFailure(exception: e));
      } finally {
        event.completer?.complete();
      }
    });
    on<ChangeQuantity>((event, emit) async {
      try {
        final cart = (state as BagLoaded).cart;
        final id = event.id;
        var qty = event.quantity;
        var cartList = cart.items;
        final body = await bagRepo.changeQuantity(id, qty);
        final bagList = await bagRepo.getBagList();
        if (body['success']) {
          cartList.removeWhere((element) {
            if (element.id == id) {
              element.qty = qty;
              return qty == 0;
            }
            return false;
          });
          final newCart = CartItem(
            items: cartList,
            totalSum: bagList.totalSum,
            link: cart.link,
          );
          if (cartList.isEmpty) {
            Func().getInitParams();
            emit(BagEmpty());
          } else {
            emit(BagLoaded(cart: newCart));
            Func().getInitParams();
            Func().showSnackbar(
                event.context, 'Количество товара изменено', body['success']);
          }
        } else {
          Func().showSnackbar(event.context, body['message'], body['success']);
        }
      } catch (e) {
        emit(BagLoadingFailure(exception: e));
      }
    });
  }
}
