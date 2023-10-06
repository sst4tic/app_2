import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yiwumart/screens/payment_screen.dart';
import 'package:yiwumart/util/function_class.dart';
import '../../util/constants.dart';
import '../../util/user.dart';
import '../edit_profile_bloc/abstract_edit.dart';
part 'purchase_event.dart';

part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final AbstractEdit editProfileRepo;

  PurchaseBloc({required this.editProfileRepo}) : super(PurchaseLoading()) {
    on<LoadPurchase>((event, emit) async {
      try {
        emit(PurchaseLoading());
        var user = await editProfileRepo.getProfile();
        emit(
            PurchaseLoaded(id: event.id, user: user, totalSum: event.totalSum));
      } catch (e) {
        emit(PurchaseError(error: e));
      } finally {
        event.completer?.complete();
      }
    });
    on<PurchaseCheckout>((event, emit) async {
      final Dio dio = Dio();
      try {
        Future checkoutPost() async {
          Map<String, dynamic> data = {
            "cart_id": event.cartId,
            "phone": '+7${event.phone}',
            "address": event.address,
            "comment": event.comments,
            "name": event.name,
            "payment_method": event.paymentMethod,
            "online": event.online,
            "city": "Алматы",
            "email": "aman@gmail.com",
          };
          var url = '${Constants.API_URL_DOMAIN_V3}checkout';
          final Response response = await dio.post(url,
              options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                },
                headers: Constants.headers(),
              ),
              data: FormData.fromMap(data));

          final body = response.data;
          return body;
        }

        var resp = await checkoutPost();
        if(resp['success'] != null) {
          // ignore: use_build_context_synchronously
          Func().showSuccessPurchase(context: event.context);
        } else {
          // ignore: use_build_context_synchronously
          Func().showSnackbar(event.context, resp['success'] != null
            ? 'Успешно'
            : resp['errors'].toString(), resp['success'] != null ? true : false);
        }
        if (resp['link'] != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
              event.context,
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentScreen(url: resp['link'])));
        }
      } catch (e) {
        print(e);
        emit(PurchaseError(error: e));
      }
    });
  }
}
