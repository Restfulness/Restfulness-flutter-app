import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/category/categories_bloc.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/blocs/social/social_bloc.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/config/app_config.dart';
import 'package:restfulness/src/helpers/social_date_picker.dart';
import 'package:restfulness/src/screens/search_screen.dart';
import 'package:restfulness/src/screens/settings_screen.dart';
import 'package:restfulness/src/screens/social_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'home_screen.dart';

String baseUrl = AppConfig.instance.values.apiBaseUrl;

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  bool isDemo = false;

  int homeIndex = 0;
  int socialIndex = 1;
  int searchIndex = 2;

  int _currentIndex = 0;

  bool isDataPicked = false;

  final List<Widget> _children = [
    HomeScreen(),
    SocialScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];
  String _title;

  LinksBloc linkBloc;
  CategoriesBloc categoriesBloc;
  SocialBloc socialBloc;

  @override
  initState() {
    super.initState();
    _title = "Home";

    _readUrl().then((value) {
      if (value != "") {
        baseUrl = value;
      }
      if (baseUrl.contains("api.restfulness.app")) {
        isDemo = true;
      } else {
        isDemo = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    linkBloc = LinksProvider.of(context);
    socialBloc = SocialProvider.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: appBarColor,
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          centerTitle: true,
          title: Text(
            _title,
            style: TextStyle(color: Colors.black),
          ),
          leading: Stack(
            children: [
              if (isDemo)
                Positioned(
                  child: InkWell(
                    onTap: () => {showAlertDialog(context)},
                    child: Container(
                      width: 40,
                      height: 20,
                      decoration: new BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Center(
                        child: Text(
                          "Demo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  top: 20,
                  left: 10,
                ),
            ],
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            if (isDataPicked && _currentIndex == socialIndex)
              IconButton(
                icon: Icon(
                  MdiIcons.restart,
                  color: primaryColor,
                ),
                onPressed: () {
                  _deletePickedDate();
                  socialBloc.fetchSocial(
                      page: firstPage, pageSize: firstPageSize);
                  setState(() {
                    isDataPicked = false;
                  });
                },
              ),
            if (_currentIndex == socialIndex)
              IconButton(
                icon: Icon(
                  MdiIcons.calendar,
                  color: primaryColor,
                ),
                onPressed: () {
                  SocialDatePicker socialDatePicker =
                      new SocialDatePicker(onDateSelect: (value) {
                    setState(() {
                      isDataPicked = value;
                    });
                  });
                  socialDatePicker.pickTime(context);
                },
              ),
          ],
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: MdiIcons.home, title: "Home"),
            TabData(iconData: MdiIcons.earth, title: "Social"),
            TabData(iconData: MdiIcons.magnify, title: "Search"),
            TabData(iconData: MdiIcons.cog, title: "Settings")
          ],
          onTabChangedListener: (position) {
            setState(() {
              onTabTapped(position);
              _currentIndex = position;
            });
          },
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      switch (index) {
        case 0:
          _title = "Home";
          break;
        case 1:
          _title = "Social";
          break;
        case 2:
          _title = "Search";
          break;
        case 3:
          _title = "Settings";

          break;
      }
    });

    if (index != searchIndex) {
      linkBloc.resetSearch();
    }
    if (index == socialIndex) {
      socialBloc.resetSocial();
      socialBloc.fetchSocial(page: firstPage, pageSize: firstPageSize);
      ;
    } else {
      isDataPicked = false;
    }
    if (index == homeIndex) {
      linkBloc.refreshLinks();
    }
  }

  Future<String> _readUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'urlAddress';
    final value = prefs.getString(key) ?? '';
    return value;
  }

  Future<bool> _deletePickedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'pickedDate';
    return prefs.remove(key);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Demo"),
      content: RichText(
        text: new TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'You are using the demo server which is '),
            TextSpan(
                text: 'api.restfulness.app, ',
                style: new TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    'if you want to set a new server please go to the settings'),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
