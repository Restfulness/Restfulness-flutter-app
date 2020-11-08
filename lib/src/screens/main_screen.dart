import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/category/categories_bloc.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/screens/home_screen.dart';
import 'package:restfulness/src/screens/search_screen.dart';
import 'package:restfulness/src/widgets/drawer_widget.dart';

import 'category_screen.dart';

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
  bool _isOnHomePage = true;
  final List<Widget> _children = [
    HomeScreen(),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(MdiIcons.home),
            label: 'Home',
          ),
          new BottomNavigationBarItem(
            icon: Icon(MdiIcons.magnify),
            label: 'Search',
          ),
          new BottomNavigationBarItem(
            icon: Icon(MdiIcons.pound),
            label: 'Categories',
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: new Builder(builder: (BuildContext context) {
        HomeScreen homeScreen = new HomeScreen();
        return homeScreen.buildFloatingActionButton(
            context, linkBloc, _isOnHomePage);
      }),
      drawer: DrawerWidget(),
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
          _title = "Categories";
          break;
      }
    });
    if (index != homeIndex) {
      _isOnHomePage = false;
    } else {
      _isOnHomePage = true;
    }
    if (index != searchIndex) {
      linkBloc.resetSearch();
    }
  }
}
