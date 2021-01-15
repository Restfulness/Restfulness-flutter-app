import 'dart:io';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'src/app.dart';
import 'src/config/app_config.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';


void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  AppConfig(
      flavor: Flavor.DEV,
      color: primaryColor,
      values: AppValues(apiBaseUrl: 'https://api.restfulness.app'));
  runApp(App());
}
