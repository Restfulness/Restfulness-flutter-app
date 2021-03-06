import 'package:restfulness/src/helpers/api_helper.dart';
import 'package:restfulness/src/models/signup_model.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:restfulness/src/resources/repository.dart';

class AuthorizationApiProvider implements UserSource {
  ApiHelper apiHelper = ApiHelper();

  Future<UserModel> login(String username, String password) async {
    final response = await apiHelper.post(
      "user/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, String>{'username': username, 'password': password},
    );

    Map<String, dynamic> toJson = new Map<String, dynamic>();
    toJson["username"] = username;
    toJson["password"] = password;
    toJson["accessToken"] = response["access_token"];

    return UserModel.fromJson(toJson);
  }

  Future<SignUpModel> signUp(String username, String password) async {
    final response = await apiHelper.post(
      "user/signup",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: <String, String>{'username': username, 'password': password},
    );

    return SignUpModel.fromJson(response);
  }
}
