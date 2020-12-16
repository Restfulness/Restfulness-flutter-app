import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/helpers/time_ago_since_date.dart';
import 'package:restfulness/src/widgets/social/social_user_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialUserListWidget extends StatelessWidget {
  final String username;
  final String lastUpdate;
  final int totalLinks;
  final int userId;

  SocialUserListWidget(
      {this.username, this.lastUpdate, this.totalLinks, this.userId});

  @override
  Widget build(BuildContext context) {
    final linkBloc = LinksProvider.of(context);
    _saveTime();
    return Container(
      height: 80,
      child: InkWell(
        onTap: () {
          _readPreviewSwitch().then((value) {
            DateTime date = DateTime.parse(lastUpdate);
            linkBloc.fetchSocialUserLinks(userId , DateTime.now().subtract(Duration(days: 7)));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SocialUserLinks(
                      username: username,
                      preview: value,
                    ))).then((context) {
              linkBloc.restSocialList();
            });
          });
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
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 30,
                  height: double.infinity,
                  child: Image.asset(
                    "assets/images/default.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                child: Text(
                  "$username",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                top: 28,
                left: 60,
              ),
              Positioned(
                child: Text(
                  "$totalLinks",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                top: 25,
                right: 32,
              ),
              Positioned(
                child: Text(
                  "${TimeAgoSinceDate.time(lastUpdate)}",
                  style: TextStyle(fontSize: 12),
                ),
                top: 8,
                right: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _saveTime() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'lastSeen';
    final isSaved = prefs.setString(key, DateTime.now().toString());
    return isSaved;
  }


  Future<bool> _readPreviewSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'preview';
    final value = prefs.getBool(key) ?? true;
    return value;
  }

}