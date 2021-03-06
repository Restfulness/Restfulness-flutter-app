import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/screens/app_intro_screen.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login_screen.dart';
import 'main_screen.dart';

class DecisionScreen extends StatefulWidget {
  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen> {
  String _state = 'Welcome';
  final repository = new Repository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _readIntro().then((value) async {
        if (!value) {
          _redirectToPage(context, AppIntroScreen());
        } else {
          await repository.initializationAuth;

          final user = await repository.currentUser();

          if (user == null) {
            _redirectToPage(context, LoginScreen());
          } else {
            try {
              repository.clearUserCache();
              await repository.login(user.username, user.password);

              goToMainScreen(context);
            } catch (e) {
              if (JsonUtils.isValidJSONString(e.toString())) {
                _state = json.decode(e.toString())["msg"];
              } else {
                setState(() {
                  _state = "Unexpected server error ";
                });
              }
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: buildLoading(),
        ),
      ),
    );
  }

  void goToMainScreen(BuildContext context) {
    // TODO goToMainScreen need a separate class we use this method here, decision_screen and app_intro_screen

    final linkBloc = LinksProvider.of(context);
    final categoriesBloc = CategoriesProvider.of(context);
    final socialBloc = SocialProvider.of(context);

    linkBloc.fetchLinks(firstPage, firstPageSize);
    categoriesBloc.fetchCategories();

    _readTime().then((value) {
      if (value.isEmpty) {
        socialBloc.fetchSocial(page: firstPage, pageSize: firstPageSize);
      } else {
        DateTime date = DateTime.parse(value);
        socialBloc.fetchSocial(
            date: date, page: firstPage, pageSize: firstPageSize);
      }
    });

    // // TODO refactor after we have all users profile info in login response
    repository.fetchPublicLinksSetting().then((value) {
      _savePublicSwitch(value);
    });

    _redirectToPage(context, MainScreen());
  }

  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
        MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    final bool nav = await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/'));
    if (nav == true) {
      //TODO: init
    }
  }

  Future<String> _readTime() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'lastSeen';
    final value = prefs.getString(key) ?? '';
    return value;
  }

  Future<bool> _readIntro() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'intro';
    final value = prefs.getBool(key) ?? false;
    return value;
  }

  Future<bool> _savePublicSwitch(bool preview) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'publicLinks';
    final isSaved = prefs.setBool(key, preview);
    return isSaved;
  }

  Widget buildLoading() {
    return Text(
      _state,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 26.0, color: primaryColor),
    );
  }
}
