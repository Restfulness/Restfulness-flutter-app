import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/screens/home_screen.dart';
import 'package:restfulness/src/screens/search_screen.dart';
import 'package:restfulness/src/widgets/drawer_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int homeIndex = 0;
  int searchIndex = 1;

  int _currentIndex = 0;
  bool _isOnHomePage = true;
  final List<Widget> _children = [
    HomeScreen(),
    SearchScreen(),
  ];
  String _title;

  LinksBloc bloc;

  @override
  initState() {
    super.initState();
    _title = "Home";
  }

  @override
  Widget build(BuildContext context) {
    bloc = LinksProvider.of(context);
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
            label: 'Group',
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: new Builder(builder: (BuildContext context) {
        HomeScreen homeScreen = new HomeScreen();
        return homeScreen.buildFloatingActionButton(
            context, bloc, _isOnHomePage);
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
          _title = "Group";
          break;
      }
    });
    if (index != homeIndex) {
      _isOnHomePage = false;
    } else {
      _isOnHomePage = true;
    }
    if (index != searchIndex) {
        bloc.resetSearch();
    }
  }
}
