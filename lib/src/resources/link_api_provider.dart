import 'package:restfulness/src/helpers/api_helper.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/resources/repository.dart';


class LinkApiProvider implements LinkSource {
  ApiHelper apiHelper = ApiHelper();

  @override
  Future<LinkModel> insertLink(
      List<String> category, String url, String token) async {
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
  Future<List<int>> fetchAllLinks() {
    // TODO: implement fetchAllLinks
    return null;
  }

  @override
  Future<LinkModel> fetchLink(int id) {
    // TODO: implement fetchLink
    return null;
  }
}
