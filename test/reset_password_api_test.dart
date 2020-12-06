import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/resources/reset_password_api_provider.dart';

const fakeSearchUsernameSuccess = {
  "hashed_data": "eyJhb"
};
const fakeSearchUsernameFailed404 = {
  "msg": "Username not found"
};

const fakeVerifySuccess = {
  "reset_password_token": "token"
};
const fakeVerifyFailed400 = {
  "msg": "User inputed code is incorrect"
};
const fakeVerifyFailed401 = {
  "msg": "Token invalid!"
};

const fakeNewPassSuccess = {
  "msg": "Password reseted successfully."
};
const fakeNewPassFailed401 = {
  "msg": "Token invalid!"
};
const fakeNewPassFailed500 = {
  "msg": "Failed due to server error"
};

void main() {
  ResetPasswordApiProvider apiProvider;

  setUp(() {
    AppConfig(
        flavor: Flavor.DEV,
        values: AppValues(apiBaseUrl: 'http://localhost:5000'));

    apiProvider = new ResetPasswordApiProvider();
  });

  test("Test finding email", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSearchUsernameSuccess), 200);
    });

    final search = await apiProvider.forgotPass(email: 'test@test.com');
    expect(search, 'eyJhb');
  });

  test("Test if cant find any email", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSearchUsernameFailed404), 404);
    });

    try {
      await apiProvider.forgotPass(email: 'test123@test.com');
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "Username not found");
    }
  });

  test("Test valid code", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeVerifySuccess), 200);
    });

    final code = await apiProvider.verifyCode(hash: "eyJhb" , code: 12345678);
    expect(code, 'token');
  });

  test("Test if code is not valid", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeVerifyFailed400), 400);
    });

    try {
      await apiProvider.verifyCode(hash: "eyJhb" , code: 22222222);
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "User inputed code is incorrect");
    }
  });

  test("Test if token is not valid for code verification", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeVerifyFailed401), 401);
    });

    try {
      await apiProvider.verifyCode(hash: "invalid" , code: 12345678);
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "Token invalid!");
    }
  });

  test("Test new password", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeNewPassSuccess), 200);
    });

    final reset = await apiProvider.resetPass(token: "token",newPass: "newPass");
    expect(reset, "Password reseted successfully.");
  });

  test("Test if token is not valid for new password", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeNewPassFailed401), 401);
    });

    try {
      await apiProvider.resetPass(token: "invalid",newPass: "newPass");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"],
          "Token invalid!");
    }
  });

}
