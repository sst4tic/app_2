import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:yiwumart/main.dart';
import 'package:yiwumart/util/cart_list.dart';
import '../../util/constants.dart';
import '../../util/function_class.dart';
import '../../util/product.dart';
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
              emit(BagLoaded(
                  cart: bagList,
                  selectedItems: selectedItems,
                  allSelected: false));
            } else {
              final products = await Func.getProducts();
              emit(BagEmpty(products: products));
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
            final products = await Func.getProducts();
            emit(BagEmpty(products: products));
          } else {
            emit(BagLoaded(
                cart: newCart,
                selectedItems: selectedItems,
                allSelected: isSelectAll));
            Func().getInitParams();
            // ignore: use_build_context_synchronously
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
      void selectAllItems() {
        selectedItems.clear();
        selectedItems
            .addAll((state as BagLoaded).cart.items.map((e) => e.id).toList());
        isSelectAll = true;
      }

      void unselectAllItems() {
        selectedItems.clear();
        isSelectAll = false;
      }

      if(event.isSelectAll) {
        if(selectedItems.length == (state as BagLoaded).cart.items.length) {
          unselectAllItems();
        } else {
          selectAllItems();
        }
      } else {
        if (selectedItems.contains(id)) {
          selectedItems.remove(id);
          isSelectAll = false;
        } else {
          selectedItems.add(id);
          isSelectAll = false;
        }
      }
      emit(BagLoaded(
          cart: (state as BagLoaded).cart,
          selectedItems: selectedItems,
          allSelected: isSelectAll));
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
          Func().getInitParams();
          if (cartList.isEmpty) {
            final products = await Func.getProducts();
            emit(BagEmpty(products: products));
          } else {
            emit(BagLoaded(
                cart: newCart,
                selectedItems: selectedItems,
                allSelected: isSelectAll));
            Func().getInitParams();
            Func().showSnackbar(
                navKey.currentContext!, body['message'], body['success']);
          }
        } else {
          Func().showSnackbar(navKey.currentContext!, body['errors'].toString(),
              body['success']);
        }
        navKey.currentContext!.loaderOverlay.hide();
      } catch (e) {
        emit(BagLoadingFailure(exception: e));
      }
    });
  }
}
