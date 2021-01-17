import 'dart:io';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'src/app.dart';
import 'src/config/app_config.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:window_size/window_size.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Restfulness');
    setWindowMaxSize(const Size(480, 800));
    setWindowMinSize(const Size(480, 800));
  }
  AppConfig(
      flavor: Flavor.DEV,
      color: primaryColor,
      values: AppValues(apiBaseUrl: 'https://api.restfulness.app'));
  runApp(App());
}
