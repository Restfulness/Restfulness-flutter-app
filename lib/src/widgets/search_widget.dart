import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_widget.dart';
import 'lists/link_list_simple_widget.dart';
import 'lists/link_search_list_widget.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final GlobalKey<LinkSearchListWidgetScreen> _key = GlobalKey();

  LinksBloc bloc;
  int _state = 0;
  TextEditingController searchController;

  bool isHaveSearchResult;

  bool isShowPreview = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    searchController = new TextEditingController();

    isHaveSearchResult = false;

    _readPreviewSwitch().then((value) {
      isShowPreview = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = LinksProvider.of(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(11, 15, 0, 15),
                  child: Material(
                    elevation: 6.0,
                    borderRadius: BorderRadius.circular(30),
                    child: _buildSearchField(context, bloc),
                  ),
                  height: 50,
                  width: double.infinity,
                ),
                flex: 4,
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (searchController.text != '') {
                      bloc.resetSearch();
                      bloc.searchLinks(searchController.text);
                      setState(() {
                        _state = 1;
                      });
                    }
                  },
                  elevation: 8.0,
                  color: primaryColor,
                  child: _buildButtonIcon(),
                  padding: EdgeInsets.all(14.0),
                  shape: CircleBorder(),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildList(bloc),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context, LinksBloc bloc) {
    return TextField(
      onChanged: (word) {
        bloc.resetSearch();
        print("reset");
        if (word != '') {
          bloc.searchLinks(word);
        }
      },
      controller: searchController,
      decoration: InputDecoration(
          hintText: 'Search links',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
    );
  }

  Widget _buildButtonIcon() {
    if (_state == 1) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        //FIXME: shouldn't use delay!
        setState(() {
          _state = 0;
        });
      });
      return SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        height: 25.0,
        width: 25.0,
      );
    } else {
      return Icon(
        MdiIcons.magnify,
        color: Colors.white,
      );
    }
  }

  Widget _buildList(LinksBloc bloc) {
    return StreamBuilder(
        stream: bloc.search,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (isShowPreview) {
              return LinkSearchListWidget(key: _key);
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          if (isShowPreview) {
            _key.currentState.setCardList(snapshot.data);
            return LinkSearchListWidget(key: _key);
          } else {
            if (snapshot.data.length <= 0) {
              return CategoryWidget();
            } else {
              return LinkListSimpleWidget(list: snapshot.data);
            }
          }
        });
  }

  void hideIndicator() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          searchController.clear();
          _state = 0;
        });
      });
    });
  }

  Future<bool> _readPreviewSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'preview';
    final value = prefs.getBool(key) ?? true;
    return value;
  }
}
