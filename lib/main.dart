import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/config/app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Restfulness Dev',
    build: 'development',
    apiBaseUrl: 'http://localhost:5000',
    child: App(),
  );
  runApp(configuredApp);
}
