import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/abstract_edit.dart';
import 'package:http/http.dart' as http;
import '../../util/constants.dart';
import '../../util/user.dart';

class EditRepo implements AbstractEdit {
  @override
  Future getProfile() async {
    var url = '${Constants.API_URL_DOMAIN}action=user_profile';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    final user = User.fromJson(body['data']);
    return user;
  }

  @override
  Future editProfile(User user) async {
    final Dio dio = Dio();
    try {
      Response response = await dio.get(
          '${Constants.API_URL_DOMAIN}action=user_profile_edit_post&',
          queryParameters: {
            "name": user.name,
            "surname": user.surname,
            "bdate": user.bdate,
            "gender": user.gender,
          },
          options: Options(headers: Constants.headers()));
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e);
      return e.response;
    }
  }
}
