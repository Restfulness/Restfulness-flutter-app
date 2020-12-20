import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:restfulness/constants.dart';

class SettingVersionNumber extends StatefulWidget {
  @override
  _SettingVersionNumberState createState() => _SettingVersionNumberState();
}

class _SettingVersionNumberState extends State<SettingVersionNumber> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
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
                "Version",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Positioned(
              child: buildVersionNumber(),
              right: 38,
              top: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVersionNumber() {
    return Center(
      child: Text(
        _packageInfo.version,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
