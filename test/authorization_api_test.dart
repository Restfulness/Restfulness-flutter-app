import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restfulness/src/resources/authorization_api_provider.dart';

const fakeLoginResponse = {"access_token": "string_token"};
const fakeLoginFailedResponse = {"msg": "Bad username or password"};
const fakeSignUpResponse = {"msg": "User created", "username": "test"};
const fakeSignUpFailedResponse = {"msg": "Username exists"};

void main() {
  AuthorizationApiProvider apiProvider;

  setUp(() {
    apiProvider = new AuthorizationApiProvider();
  });

  test("Test Login api if username and password is correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLoginResponse), 200);
    });

    final user = await apiProvider.login("test", "test");
    expect(user.accessToken, "string_token");
  });

  test("Test Login api if username or password is not correct", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeLoginFailedResponse), 401);
    });

    try {
      await apiProvider.login("wrong", "wrong");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Bad username or password");
    }
  });

  test("Test SignUp api if username is not exists", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSignUpResponse), 200);
    });

    final user = await apiProvider.signUp("newUser", "userPassword");
    expect(user.msg, "User created");
  });

  test("Test SignUp api if username is exists", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fakeSignUpFailedResponse), 403);
    });

    try {
      await apiProvider.signUp("test", "test");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Username exists");
    }
  });
}
