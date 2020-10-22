import 'dart:convert';

class JsonUtils{
  static bool isValidJSONString(str) {
    try {
      jsonDecode(str);
    } catch (e) {
      return false;
    }
    return true;
  }
}