import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/category/categories_bloc.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/blocs/social/social_bloc.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/helpers/social_date_picker.dart';
import 'package:restfulness/src/screens/search_screen.dart';
import 'package:restfulness/src/screens/settings_screen.dart';
import 'package:restfulness/src/screens/social_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'home_screen.dart';

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

    _readDemo().then((value) {
      setState(() {
        isDemo = value;
      });
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
              if(isDemo)
              Positioned(
                child: InkWell(
                  onTap: () => {
                    showAlertDialog(context)
                  },
                  child: Text(
                    "Demo",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                top: 23,
                left: 20,
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
                  socialBloc.fetchSocial(null);
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
      socialBloc.fetchSocial(null);
    } else {
      isDataPicked = false;
    }
  }

  Future<bool> _readDemo() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'demo';
    final isSaved = prefs.getBool(key) ?? '';
    return isSaved;
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Demo"),
      content:  RichText(
        text: new TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
             TextSpan(text: 'You are using the demo URL which is '),
             TextSpan(text: 'api.restfulness.app, ', style: new TextStyle(fontWeight: FontWeight.bold)),
             TextSpan(text: 'if you want to set a new URL please go to the settings'),
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
