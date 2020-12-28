import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/screens/login/login_screen.dart';

import '../../../constants.dart';

class SettingLogout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final linkBloc = LinksProvider.of(context);
    final socialBloc = SocialProvider.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: ButtonTheme(
        minWidth: double.infinity,
        height: 50.0,
        child: RaisedButton(
          elevation: 5.0,
          child: Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          color: primaryColor,
          disabledColor: primaryLightColor,
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          onPressed: () {
            linkBloc.resetLinks();
            socialBloc.resetSocial();

            Repository repository = new Repository() ;
            repository.clearUserCache();
            repository.clearLinkCache();
            _redirectToPage(context, LoginScreen());
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
    MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    final bool nav = await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/'));
  }
}
