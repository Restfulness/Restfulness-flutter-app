import 'dart:convert';

class LinkModel {
  int id;
  String url;
  List<dynamic> categories;

  LinkModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    url = parsedJson['url'];
    categories = parsedJson['categories'] ?? [];
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
}
