import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingGithubSponsor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          _launchURL();
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Text(
                        "Support us in github",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Icon(
                        MdiIcons.heart,
                        color: Colors.red,
                        size: 15,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    if (await canLaunch('https://restfulness.app/#loveit')) {
      await launch('https://restfulness.app/#loveit');
    }
  }
}
