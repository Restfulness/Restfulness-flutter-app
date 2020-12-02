import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/helpers/api_helper.dart';

class ResetPasswordApiProvider {
  ApiHelper apiHelper = ApiHelper();

  Future<String> forgotPass({@required String email}) async {
    final response = await apiHelper.post(
      "user/password/forget",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, dynamic>{'username': email},
    );

    return response["hashed_data"];
  }

  Future<String> verifyCode({@required String hash, @required int code}) async {
    final response = await apiHelper.post(
      "user/password/verify",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, dynamic>{'hashed_data': hash, 'user_input': code},
    );

    return response["reset_password_token"];
  }

  Future<String> resetPass({@required String token, @required String newPass}) async {
    final response = await apiHelper.post(
      "user/password/reset",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, dynamic>{'reset_password_token': token, 'new_password': newPass},
    );

    return response["msg"];
  }
}
