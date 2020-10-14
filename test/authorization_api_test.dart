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
    apiProvider.client = MockClient((request) async {
      return Response(json.encode(fakeLoginResponse), 200);
    });

    final user = await apiProvider.login("test", "test");
    expect(user.accessToken, "string_token");
  });

  test("Test Login api if username or password is not correct", () async {
    apiProvider.client = MockClient((request) async {
      return Response(json.encode(fakeLoginFailedResponse), 401);
    });

    final user = await apiProvider.login("wrong", "wrong");
    expect(user, null);//TODO need refactoring after HTTP request handler is implemented
  });

  test("Test SignUp api if username is not exists", () async {
    apiProvider.client = MockClient((request) async {
      return Response(json.encode(fakeSignUpResponse), 200);
    });

    final user = await apiProvider.signUp("newUser", "userPassword");
    expect(user.msg, "User created");
  });

  test("Test SignUp api if username is exists", () async {
    apiProvider.client = MockClient((request) async {
      return Response(json.encode(fakeSignUpFailedResponse), 403);
    });

    final user = await apiProvider.signUp("test", "test");
    expect(user, null);
  });
}
