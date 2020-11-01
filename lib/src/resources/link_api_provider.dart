import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/helpers/api_helper.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/models/search_model.dart';
import 'package:restfulness/src/resources/repository.dart';

class LinkApiProvider implements LinkSource {
  ApiHelper apiHelper = ApiHelper();

  @override
  Future<int> insertLink(
      {List<String> category, String url, @required String token}) async {
    final response = await apiHelper.post(
      "links",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: <String, dynamic>{'categories': category, 'url': url},
    );
    Map<String, dynamic> toJson = new Map<String, dynamic>();

    return response["id"];
  }

  @override
  Future<List<LinkModel>> fetchAllLinks({@required String token}) async {
    List<LinkModel> links = new List<LinkModel>();

    final response = await apiHelper.get("links", headers: <String, String>{
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
      "links/$id",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    return LinkModel.fromJson(response);
  }

  @override
  Future<bool> deleteLink({String token, int id}) async {
    final response =
        await apiHelper.delete("links/$id", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    return true;
  }

  @override
  Future<List<SearchLinkModel>> searchLink({String token, String word}) async {

    List<SearchLinkModel> links = new List<SearchLinkModel>();

    final response = await apiHelper.get(
      "links/search/$word",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
   final search = SearchModel.fromJson(response['search']).links;
    for (var link in search) {
      links.add(link);
    }
    return links;
  }
}
