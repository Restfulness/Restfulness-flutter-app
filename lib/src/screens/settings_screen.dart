import 'package:flutter/material.dart';
import 'package:restfulness/src/widgets/settings/setting_config_address.dart';
import 'package:restfulness/src/widgets/settings/setting_logout.dart';
import 'package:restfulness/src/widgets/settings/setting_preview_switch.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        SettingConfigAddress(),
        SettingPreviewSwitch(),
        SettingLogout(),
      ],
    ) ;
  }


}