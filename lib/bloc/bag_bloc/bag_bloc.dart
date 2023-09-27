import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:yiwumart/main.dart';
import 'package:yiwumart/util/cart_list.dart';
import '../../util/constants.dart';
import '../../util/function_class.dart';
import 'abstract_bag.dart';

part 'bag_event.dart';

part 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  final AbstractBag bagRepo;
  BagBloc({required this.bagRepo}) : super(BagInitial()) {
    Set<int> selectedItems = <int>{};
    bool isSelectAll = false;

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
              // bagList.items.map((e) => selectedItems.add(e.id)).toList();
              print(selectedItems);
              emit(BagLoaded(cart: bagList, selectedItems: selectedItems, allSelected: false));
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
        event.context.loaderOverlay.show();
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
            cartId: cart.cartId,
          );
          if (cartList.isEmpty) {
            Func().getInitParams();
            emit(BagEmpty());
          } else {
            emit(BagLoaded(cart: newCart, selectedItems: selectedItems, allSelected: isSelectAll));
            Func().getInitParams();
            Func().showSnackbar(
                event.context, 'Количество товара изменено', body['success']);
          }
        } else {
          Func().showSnackbar(event.context, body['message'], body['success']);
        }
        event.context.loaderOverlay.hide();
      } catch (e) {
        emit(BagLoadingFailure(exception: e));
      }
    });
    on<SelectItem>((event, emit) {
      final id = event.id;
      var selectedItems = (state as BagLoaded).selectedItems;
      if (selectedItems.contains(id)) {
        selectedItems.remove(id);
      } else {
        selectedItems.add(id);
      }
      if(selectedItems.length == (state as BagLoaded).cart.items.length) {
        isSelectAll = true;
      } else {
        isSelectAll = false;
      }
      print(isSelectAll);
      emit(BagLoaded(cart: (state as BagLoaded).cart, selectedItems: selectedItems, allSelected: isSelectAll));
    });

    on<DeleteSelected>((event, emit) async {
      try {
        navKey.currentContext!.loaderOverlay.show();
        final cart = (state as BagLoaded).cart;
        final cartList = cart.items;
        final ids = event.ids;
        final body = await bagRepo.deleteSelected(ids);
        if (body['success']) {
          cartList.removeWhere((element) => ids.contains(element.id));
          final newCart = CartItem(
            items: cartList,
            totalSum: cart.totalSum,
            cartId: cart.cartId,
          );
          if (cartList.isEmpty) {
            emit(BagEmpty());
          } else {
            emit(BagLoaded(cart: newCart, selectedItems: selectedItems, allSelected: isSelectAll));
            Func().getInitParams();
            Func().showSnackbar(
                navKey.currentContext!, body['message'], body['success']);
          }
        } else {
          Func().showSnackbar(navKey.currentContext!, body['errors'].toString(), body['success']);
        }
        navKey.currentContext!.loaderOverlay.hide();
      } catch (e) {
        emit(BagLoadingFailure(exception: e));
      }
    });
  }
}
