import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/category/categories_bloc.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/screens/home_screen.dart';
import 'package:restfulness/src/screens/search_screen.dart';
import 'package:restfulness/src/widgets/drawer_widget.dart';

import '../../constants.dart';
import 'category_screen.dart';
import 'new_home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int homeIndex = 0;
  int searchIndex = 1;
  int categoryIndex = 2;

  int _currentIndex = 0;

  final List<Widget> _children = [
    NewHomeScreen(),
    SearchScreen(),
    CategoryScreen(),
  ];
  String _title;

  LinksBloc linkBloc;
  CategoriesBloc categoriesBloc;

  @override
  initState() {
    super.initState();
    _title = "Home";
  }

  @override
  Widget build(BuildContext context) {
    linkBloc = LinksProvider.of(context);

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
          brightness: Brightness.light,
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: MdiIcons.home, title: "Home"),
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
          _title = "Search";
          break;
        case 2:
          _title = "Settings";

          break;
      }
    });

    if (index != searchIndex) {
      linkBloc.resetSearch();
    }
  }
}
