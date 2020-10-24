import 'dart:convert';

import 'category_model.dart';

class LinkModel {
  int id;
  String url;
  List<CategoryModel> categories;

  LinkModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    url = parsedJson['url'];
    categories = toCategory(parsedJson['categories']);
  }

  LinkModel.fromDB(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    url = parsedJson['url'];
    categories = jsonDecode(parsedJson['categories']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      "categories": jsonEncode(categories),
    };
  }

  List<CategoryModel> toCategory(categories) {
    List<CategoryModel> categoryList = new List<CategoryModel>();
    for (var cat in categories) {
      categoryList.add(CategoryModel.fromJson(cat));
    }
    return categoryList;
  }
}
