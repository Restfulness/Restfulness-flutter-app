import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/resources/link_api_provider.dart';

const fakeLinkAddSuccess = {"id": 1};
const fakeLoginFailed400 = {
  "msg":
      "Link is not valid. Valid link looks like:http://example.com or https://example.com"
};
const fakeLoginFailed500 = {"msg": "Failed to add new link"};

void main() {
  LinkApiProvider apiProvider;

  setUp(() {
    AppConfig(
        flavor: Flavor.DEV,
        values: AppValues(apiBaseUrl: 'http://localhost:5000'));

    apiProvider = new LinkApiProvider();
  });

  test("Test add link API if everything is correct", () async {

    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLinkAddSuccess), 200);
    });

    final link =
        await apiProvider.insertLink(["programming"], "http://github.com","token");
    expect(link.id, 1);
  });

  test("Test add link API if URL is not correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLoginFailed400), 400);
    });

    try {
      await apiProvider.insertLink(["programming"],"github", "token");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Link is not valid. Valid link looks like:http://example.com or https://example.com");
    }
  });

  test("Test add link API if token is not correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLoginFailed500), 500);
    });

    try {
      await apiProvider.insertLink(["programming"],"github", "wrongToken");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Failed to add new link");
    }
  });
}
