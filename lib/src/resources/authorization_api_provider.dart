import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/models/signup_model.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:restfulness/src/resources/repository.dart';


String _rootUrl ;

class AuthorizationApiProvider implements Source {
  Client client = new Client();


  void setAppUrl(BuildContext context){
    var config = AppConfig.of(context);
    _rootUrl = config.apiBaseUrl;
  }

  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      "$_rootUrl/user/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'password': username, 'username': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      Map<String, dynamic> toJson = new Map<String, dynamic>();
      toJson["username"] = username;
      toJson["password"] = password;
      toJson["accessToken"] = data["access_token"];

      return UserModel.fromJson(toJson);
    }
    return null; // TODO check http response to handling result
  }

  Future<SignUpModel> signUp(String username, String password) async {
    final response = await client.post(
      "$_rootUrl/user/signup",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'password': username, 'username': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SignUpModel.fromJson(data);
    }
    return null; // TODO check http response to handling result
  }
}
