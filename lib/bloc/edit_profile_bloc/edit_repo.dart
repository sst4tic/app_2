import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:yiwumart/bloc/edit_profile_bloc/abstract_edit.dart';
import 'package:http/http.dart' as http;
import '../../util/constants.dart';
import '../../util/user.dart';

class EditRepo implements AbstractEdit {
  @override
  Future getProfile() async {
    var url = '${Constants.API_URL_DOMAIN_V3}my';
    final response =
        await http.get(Uri.parse(url), headers: Constants.headers());
    final body = jsonDecode(response.body);
    final user = User.fromJson(body['data']);
    return user;
  }
  @override
  Future deleteAccount() async {
    var response = await http.delete(
        Uri.parse('${Constants.API_URL_DOMAIN_V3}my'),
        headers: Constants.headers()
    );
    print(response.body);
    final body = jsonDecode(response.body);
    print(body);
    return body;
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
            "phone": user.phone,
            "phone_code": user.phoneCode,
          },
          options: Options(headers: Constants.headers()));
      print('DIO RESP: ${response.data}');

      return response.data;
    } on DioError catch (e) {
      return e.response?.data;
    }
  }
}


// Future editProfile(User user) async {
//   final Dio dio = Dio();
//   try {
//     Map<String, dynamic> data = {
//       "name": user.name,
//       "surname": user.surname,
//       "bdate": user.bdate,
//       "gender": user.gender,
//       // "phone": user.phone,
//       // "phone_code": user.phoneCode,
//     };
//     Response response = await dio.put(
//         '${Constants.API_URL_DOMAIN_V3}my',
//         data: FormData.fromMap(data),
//         options: Options(headers: Constants.headers()));
//     print('DIO RESP: ${response.data}');
//
//     return response.data;
//   } on DioError catch (e) {
//     return e.response?.data;
//   }
// }