import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/resources/social_api_provider.dart';

const fakeFetchOtherUsersLinksSuccess =
  [
    {
      "last_link_added_date": "2020-12-05 19:15",
      "total_links_added_after_given_time": 11,
      "user_id": 8,
      "username": "test1@gmail.com"
    },
    {
      "last_link_added_date": "2020-12-11 05:37",
      "total_links_added_after_given_time": 8,
      "user_id": 31,
      "username": "test2@yahoo.com"
    }
  ]
;
const fakeFetchOtherUsersLinksFailed400 = {
  "msg": "Input does not match format 'YYYY-MM-DD hh:mm'"
};

const fakeFetchOtherUsersLinksFailed404 = {
  "msg": "Didn't found any activity from that time"
};


void main() {
  SocialApiProvider apiProvider;

  setUp(() {
    AppConfig(
        flavor: Flavor.DEV,
        values: AppValues(apiBaseUrl: 'http://localhost:5000'));

    apiProvider = new SocialApiProvider();
  });

  test("Test fetch other users links", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeFetchOtherUsersLinksSuccess), 200);
    });

    final social = await apiProvider.fetchSocial(token: "token",date: DateTime.now());
    expect(social.length,  2);
  });

  test("Test if date input does not match ", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeFetchOtherUsersLinksFailed400), 400);
    });

    try {
    await apiProvider.fetchSocial(token: "token",date: DateTime.now());
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "Input does not match format 'YYYY-MM-DD hh:mm'");
    }
  });

  test("Test if didn't found any activity from that time", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeFetchOtherUsersLinksFailed404), 404);
    });

    try {
      await apiProvider.fetchSocial(token: "token",date: DateTime.now());
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "Didn't found any activity from that time");
    }
  });


}
