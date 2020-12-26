import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_widget.dart';
import 'lists/link_list_simple_widget.dart';
import 'lists/link_search_list_widget.dart';

class SearchWidget extends StatefulWidget {
  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final GlobalKey<LinkSearchListWidgetScreen> _keyPreviewList = GlobalKey();
  final GlobalKey<LinkListSimpleWidgetState> _keySimpleList = GlobalKey();

  LinksBloc bloc;
  int _state = 0;
  TextEditingController searchController;

  bool isHaveSearchResult;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    searchController = new TextEditingController();
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
                    bloc.resetSearch();
                    FocusScope.of(context).unfocus();
                    if (searchController.text != '') {
                      bloc.searchLinks(
                          searchController.text, firstPage, firstPageSize);
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
          child: searchController.text.isEmpty
              ? CategoryWidget()
              : getPreviewSetting(bloc),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context, LinksBloc bloc) {
    return TextField(
      onChanged: (word) {
        bloc.resetSearch();
        if (word != '') {
          bloc.searchLinks(word, firstPage, firstPageSize);
          setState(() {
            _state = 1;
          });
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

  Widget getPreviewSetting(LinksBloc bloc) {
    return FutureBuilder(
        future: _readPreviewSwitch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return _buildList(bloc, snapshot.data);
        });
  }

  Widget _buildList(LinksBloc bloc, bool isPreview) {
    return StreamBuilder(
        stream: bloc.search,
        builder: (context, snapshot) {
          if (searchController.text.isEmpty) {
            return CategoryWidget();
          }

          if (!snapshot.hasData) {
            if (isPreview) {
              return LinkSearchListWidget(
                  key: _keyPreviewList, searchWord: searchController.text);
            } else {
              return LinkListSimpleWidget(
                  key: _keySimpleList, screenName: this.runtimeType,searchWord: searchController.text,);
            }
          }

          if (isPreview) {
            if (snapshot.data.length <= 0) {
              return LinkSearchListWidget(
                  key: _keyPreviewList, searchWord: searchController.text);
            } else {
              _keyPreviewList.currentState.setCardList(snapshot.data);
              return LinkSearchListWidget(
                  key: _keyPreviewList, searchWord: searchController.text);
            }
          } else {
            if (snapshot.data.length <= 0) {
              return LinkListSimpleWidget(
                  key: _keySimpleList, screenName: this.runtimeType,searchWord: searchController.text,);
            } else {
              _keySimpleList.currentState.setList(snapshot.data);
              return LinkListSimpleWidget(
                  key: _keySimpleList, screenName: this.runtimeType,searchWord: searchController.text,);
            }
          }
        });
  }

  Future<bool> _readPreviewSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'preview';
    final value = prefs.getBool(key) ?? true;
    return value;
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
}
