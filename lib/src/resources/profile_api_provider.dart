import 'package:flutter/material.dart';
import 'package:restfulness/src/helpers/api_helper.dart';
import 'package:restfulness/src/resources/repository.dart';

class ProfileApiProvider implements ProfileSource{

  ApiHelper apiHelper = ApiHelper();

  Future<bool> fetchPublicLinksSetting({@required String token}) async {

    final response = await apiHelper.get(
      "user/publicity",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response["publicity"];
  }

  Future<String> updatePublicLinksSetting({@required String token , bool public }) async {
    final response = await apiHelper.put(
      "user/publicity",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: <String, dynamic>{"publicity": public},
    );

    return response["msg"];
  }


}