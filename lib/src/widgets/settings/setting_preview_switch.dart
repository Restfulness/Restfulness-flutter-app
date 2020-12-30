import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPreviewSwitch extends StatefulWidget {
  @override
  _SettingPreviewSwitchState createState() => _SettingPreviewSwitchState();
}

class _SettingPreviewSwitchState extends State<SettingPreviewSwitch> {
  bool isSwitched = true;


  @override
  void initState() {
    super.initState();
    _readPreviewSwitch().then((value) {
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
                "Set on/off links preview",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Positioned(
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    _savePreviewSwitch(isSwitched);
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

  Future<bool> _readPreviewSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'preview';
    final value = prefs.getBool(key) ?? true;
    return value;
  }

  Future<bool> _savePreviewSwitch(bool preview) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'preview';
    final isSaved = prefs.setBool(key, preview);
    return isSaved;
  }
}
