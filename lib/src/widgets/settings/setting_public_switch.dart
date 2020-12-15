import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../toast_context.dart';

class SettingPublicSwitch extends StatefulWidget {
  @override
  _SettingPublicSwitchState createState() => _SettingPublicSwitchState();
}

class _SettingPublicSwitchState extends State<SettingPublicSwitch> {
  bool isSwitched = true;
  final _repository = new Repository();

  @override
  void initState() {
    super.initState();
    _readPublicSwitch().then((value) {
      print(value);
      setState(() {
        isSwitched = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                "Public links",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Positioned(
              child: Switch(
                value: isSwitched,
                onChanged: (isChanged) {
                  setState(()  {
                    isSwitched = isChanged;
                    updatePublicSetting(isChanged);
                  });
                },
                activeTrackColor: primaryLightColor,
                activeColor: primaryColor,
              ),
              right: 22,
            ),
          ],
        ),
      ),
    );
  }

  Future updatePublicSetting(bool isChanged) async{

    try {
      final msg =
          await _repository.updatePublicLinksSetting(isChanged);
      if (msg.contains("Publicity updated.")) {
        _savePublicSwitch(isSwitched);
      }
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        ToastContext(
            context, json.decode(e.toString())["msg"], false);
        setState(() {
          isSwitched = !isChanged;
        });
      } else {
        ToastContext(context, "Unexpected server error", false);
        setState(() {
          isSwitched = !isChanged;
        });
      }
    }
  }

  Future<bool> _readPublicSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'publicLinks';
    final value = prefs.getBool(key) ?? true;
    return value;
  }

  Future<bool> _savePublicSwitch(bool preview) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'publicLinks';
    final isSaved = prefs.setBool(key, preview);
    return isSaved;
  }
}
