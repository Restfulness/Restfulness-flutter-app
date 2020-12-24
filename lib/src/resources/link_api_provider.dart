import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:restfulness/constants.dart';
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

    return response["id"];
  }

  @override
  Future<List<LinkModel>> fetchAllLinks(
      {@required String token, int page, int pageSize}) async {

    List<LinkModel> links = new List<LinkModel>();

    Map<String, String> queryParams = {'page': '$page', 'page_size': '$pageSize'};
    String queryString = Uri(queryParameters: queryParams).query;

    final response = await apiHelper.get("links",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        queryParameters: queryString);

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

    return LinkModel.fromJson(response[0]);
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

  @override
  Future<List<SearchLinkModel>> fetchLinksByCategoryId(
      {String token, int id}) async {
    List<SearchLinkModel> categories = new List<SearchLinkModel>();

    final response = await apiHelper.get(
      "links/category/$id",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    final category = SearchModel.fromJson(response['category']).links;
    for (var cat in category) {
      categories.add(cat);
    }
    return categories;
  }

  @override
  Future<String> updateLinksCategory(
      {List<String> category, int id, @required String token}) async {
    final response = await apiHelper.put(
      "links/$id/category",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: <String, dynamic>{"new_categories": category},
    );

    return response["msg"];
  }

  @override
  Future<List<LinkModel>> fetchSocialUsersLinks(
      {@required String token, int id, DateTime date}) async {
    List<LinkModel> links = new List<LinkModel>();

    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(date);

    final response = await apiHelper.post(
      "user/$id/links",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: <String, dynamic>{'date_from': formatted},
    );

    for (var link in response) {
      links.add(LinkModel.fromJson(link));
    }
    return links;
  }
}
