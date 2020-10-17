import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/config/app_config.dart';

void main() {
  AppConfig(
      flavor: Flavor.DEV,
      color: Colors.blue,
      values: AppValues(apiBaseUrl: 'http://localhost:5000'));
  runApp(App());
}
