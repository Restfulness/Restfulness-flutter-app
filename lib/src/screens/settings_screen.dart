import 'package:flutter/material.dart';
import 'package:restfulness/src/widgets/settings/setting_config_address.dart';
import 'package:restfulness/src/widgets/settings/setting_logout.dart';
import 'package:restfulness/src/widgets/settings/setting_preview_switch.dart';
import 'package:restfulness/src/widgets/settings/setting_public_switch.dart';
import 'package:restfulness/src/widgets/settings/setting_show_username.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery
        .of(context)
        .viewInsets
        .bottom;
    return SingleChildScrollView(
      reverse: true,
      padding: EdgeInsets.only(bottom: bottom), child: Column(
      children: [
        SettingShowUsername(),
        SettingConfigAddress(),
        SettingPreviewSwitch(),
        SettingPublicSwitch(),
        SettingLogout(),
      ],
    ),);
  }
}
