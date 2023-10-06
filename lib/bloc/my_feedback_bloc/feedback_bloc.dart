import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:yiwumart/main.dart';
import 'package:yiwumart/util/function_class.dart';
import '../../util/constants.dart';
import '../../util/feedback.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    Future<List<FeedbackModel>> getFeedback() async {
      try {
        var url = '${Constants.API_URL_DOMAIN_V3}products-review';
        final response =
            await http.get(Uri.parse(url), headers: Constants.headers());
        final body = jsonDecode(response.body);
        final feedback = body['data']
            .map<FeedbackModel>((e) => FeedbackModel.fromJson(e))
            .toList();
        return feedback;
      } catch (e) {
        print(e);
        rethrow;
      }
    }

    Future deleteFeedback(int id) async {
      var response = await http.delete(
          Uri.parse('${Constants.API_URL_DOMAIN_V3}products-review/$id'),
          headers: Constants.headers());
      final body = jsonDecode(response.body);
      return body;
    }

    on<LoadFeedback>((event, emit) async {
      try {
        if (state is! FeedbackLoading) {
          emit(FeedbackLoading());
          final feedback = await getFeedback();
          emit(FeedbackLoaded(feedback: feedback));
        }
      } catch (e) {
        emit(FeedbackLoadingFailure(exception: e));
      } finally {
        event.completer?.complete();
      }
    });
    on<DeleteFeedback>((event, emit) async {
      try {
        final resp = await deleteFeedback(event.id);
        Func().showSnackbar(navKey.currentContext!, resp['message'], resp['success']);
        final feedback = await getFeedback();
        emit(FeedbackLoaded(feedback: feedback));
      } catch (e) {
        emit(FeedbackLoadingFailure(exception: e));
      }
    });
  }
}
