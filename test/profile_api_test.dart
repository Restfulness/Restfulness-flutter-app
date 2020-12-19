import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/resources/profile_api_provider.dart';

const fakeFetchPublicLinkSettingSuccess = {"publicity": true};

const fakeUpdatePublicLinkSettingSuccess = {"msg": "Publicity updated."};
const fakeUpdatePublicLinkSettingFailed500 = {"msg": "Server Error!"};

void main() {
  ProfileApiProvider apiProvider;

  setUp(() {
    AppConfig(
        flavor: Flavor.DEV,
        values: AppValues(apiBaseUrl: 'http://localhost:5000'));

    apiProvider = new ProfileApiProvider();
  });

  test("Test fetch user public link setting", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeFetchPublicLinkSettingSuccess), 200);
    });

    final isPublic = await apiProvider.fetchPublicLinksSetting(token: "token");
    expect(isPublic, true);
  });

  test("Test update user public link setting", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeUpdatePublicLinkSettingSuccess), 200);
    });

    final msg = await apiProvider.updatePublicLinksSetting(
        token: "token", public: false);
    expect(msg, "Publicity updated.");
  });

  test("Test update user public link setting id have server error", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeUpdatePublicLinkSettingFailed500), 500);
    });

    try {
      await apiProvider.updatePublicLinksSetting(token: "token", public: true);
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Server Error!");
    }
  });
}
