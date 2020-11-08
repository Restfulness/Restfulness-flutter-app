import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/resources/category_api_provider.dart';

const fetchCategories200 =
  [
    {
      "id": 2,
      "name": "dev"
    },
    {
      "id": 3,
      "name": "search"
    }
  ];

const fetchCategories404 = {"msg": "Category not found!"};

void main() {
  CategoryApiProvider apiProvider;

  setUp(() {
    AppConfig(
        flavor: Flavor.DEV,
        values: AppValues(apiBaseUrl: 'http://localhost:5000'));

    apiProvider = new CategoryApiProvider();
  });

  test("Test fetch category API if we have some categories", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fetchCategories200), 200);
    });

    final categories = await apiProvider.fetchAllCategories(token: "token");
    expect(categories.length, 2);
  });

  test("Test fetch category API if we didn't have any category", () async {
    apiProvider.apiHelper.client = MockClient((request) async {
      return Response(json.encode(fetchCategories404), 404);
    });

    try {
      await apiProvider.fetchAllCategories(token: "token");
    } catch (e) {
      var jsonData = json.decode(e.toString());
      expect(jsonData["msg"], "Category not found!");
    }
  });
}
