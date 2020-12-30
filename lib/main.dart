import 'package:flutter/material.dart';

import 'constants.dart';
import 'src/app.dart';
import 'src/config/app_config.dart';

void main() {
  AppConfig(
      flavor: Flavor.DEV,
      color: primaryColor,
      values: AppValues(apiBaseUrl: 'https://api.restfulness.app'));
  runApp(App());
}
