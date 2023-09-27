import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yiwumart/main.dart';
import 'package:yiwumart/util/function_class.dart';

import '../../util/constants.dart';

part 'review_post_event.dart';

part 'review_post_state.dart';

class ReviewPostBloc extends Bloc<ReviewPostEvent, ReviewPostState> {
  ReviewPostBloc() : super(ReviewPostInitial()) {
    Future postReview(
        {required int productId,
        required String body,
        required String rating}) async {
      try {
        final Dio dio = Dio();
        var url = '${Constants.API_URL_DOMAIN_V3}products-review';
        print('postReview called');
        print(url);
        Map<String, dynamic> data = {
          "product_id": productId,
          "rating": rating,
          "body": body,
        };

        Response response = await dio.post(url,
            data: data, options: Options(headers: Constants.headers()));
        if (response.data['success']) {
          Func().showSnackbar(navKey.currentContext!, response.data['message'],
              response.statusCode == 200 ? true : false);
        }
      } on DioError catch (e) {
        Func().showSnackbar(navKey.currentContext!,
            e.response!.data['errors'].toString(), false);
        print(e);
      }
    }

    on<PostReviewEvent>((event, emit) async {
      try {
        print('EvENT Called');
       await postReview(
            productId: int.parse(event.productId),
            body: event.body,
            rating: event.rating);
        event.completer?.complete();
      } catch (e) {
        print(e);
        emit(ReviewPostError(error: e));
      }
    });
  }
}
