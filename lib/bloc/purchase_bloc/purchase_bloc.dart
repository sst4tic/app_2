import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/constants.dart';
import '../../util/user.dart';
import '../edit_profile_bloc/abstract_edit.dart';
import 'package:http/http.dart' as http;
part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final AbstractEdit editProfileRepo;
  PurchaseBloc({required this.editProfileRepo}) : super(PurchaseLoading()) {
    on<LoadPurchase>((event, emit) async {
      try {
        emit(PurchaseLoading());
        var user = await editProfileRepo.getProfile();
        emit(PurchaseLoaded(id: event.id, user: user, totalSum: event.totalSum));
      } catch (e) {
        emit(PurchaseError(error: e));
      } finally {
        event.completer?.complete();
      }
    });
    on<PurchaseCheckout>((event, emit) async {
      try {
        Future checkoutPost() async {
          var url = '${Constants.API_URL_DOMAIN}action=checkout_post&cart_id=${event.cartId}&phone=${event.phone}&address=${event.address}&comments=${event.comments}';
          final response = await http.get(Uri.parse(url), headers: Constants.headers());
          final body = jsonDecode(response.body);
          return body;
        }
        var resp = await checkoutPost();
        // ignore: use_build_context_synchronously
        showCupertinoDialog(context: event.context,
            builder: (context) =>
                CupertinoAlertDialog(title: Text(resp['success'] ? 'Успешно' : 'Произошла ошибка!'),
                  content: Text(resp['success'] ? 'Данные успешно обновлены' : resp['message']),
                  actions: [
                    CupertinoDialogAction(child: const Text('Продолжить'),
                        onPressed: () => Navigator.pop(context))
                  ],));
      } catch (e) {
        emit(PurchaseError(error: e));
      }
    });
  }
}
