import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restfulness/src/helpers/api_helper.dart';
import 'package:restfulness/src/models/social_model.dart';

class SocialApiProvider {
  ApiHelper apiHelper = ApiHelper();

  Future<List<SocialModel>> fetchSocial(
      {@required String token, DateTime date}) async {
    List<SocialModel> socialUsers = new List<SocialModel>();
    String formatted;
    if (date != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
      formatted = formatter.format(date);
    } else {
      formatted = null;
    }

    final response = await apiHelper.post(
      "user/activity",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: <String, dynamic>{'date_from': formatted},
    );

    for (var users in response) {
      socialUsers.add(SocialModel.fromJson(users));
    }

    return socialUsers;
  }
}
