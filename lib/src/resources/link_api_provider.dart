import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/helpers/api_helper.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/resources/repository.dart';

class LinkApiProvider implements LinkSource {
  ApiHelper apiHelper = ApiHelper();

  @override
  Future<LinkModel> insertLink(
      {List<String> category, String url, @required String token}) async {
    final response = await apiHelper.post(
      "links/add",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: <String, dynamic>{'categories': category, 'url': url},
    );
    Map<String, dynamic> toJson = new Map<String, dynamic>();
    toJson["id"] = response["id"];
    toJson["url"] = url;
    toJson["categories"] = category;

    return LinkModel.fromJson(toJson);
  }

  @override
  Future<List<LinkModel>> fetchAllLinks({@required String token}) async {
    List<LinkModel> links = new List<LinkModel>();

    final response = await apiHelper.get("links/get", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    for (var link in response) {
      links.add(LinkModel.fromJson(link));
    }
    return links;
  }

  @override
  Future<LinkModel> fetchLink({@required int id, String token}) async {
    final response = await apiHelper.get(
      "links/add$id",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    return LinkModel.fromJson(response);
  }
}
