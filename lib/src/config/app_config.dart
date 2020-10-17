import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:restfulness/src/utils/string_utils.dart';

enum Flavor {
  DEV,
  PRODUCTION
}

class AppValues {
  final String apiBaseUrl;
  AppValues({@required this.apiBaseUrl});
}

class AppConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final AppValues values;
  static AppConfig _instance;

  factory AppConfig({
    @required Flavor flavor,
    Color color: Colors.blue,
    @required AppValues values}) {
    _instance ??= AppConfig._internal(
        flavor, StringUtils.enumName(flavor.toString()), color, values);
    return _instance;
  }

  AppConfig._internal(this.flavor, this.name, this.color, this.values);
  static AppConfig get instance { return _instance;}
  static bool isProduction() => _instance.flavor == Flavor.PRODUCTION;
  static bool isDevelopment() => _instance.flavor == Flavor.DEV;
}