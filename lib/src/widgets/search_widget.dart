import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/widgets/lists/search_link_list_widget.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  LinksBloc bloc;
  int _state = 0;
  TextEditingController searchController;

  bool isHaveSearchResult ;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    searchController = new TextEditingController();

    isHaveSearchResult = false ;
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
          if (snapshot.error != null) {
            if(_state == 0){
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(snapshot.error),
                      duration: Duration(seconds: 2))));
            }

            return Container();
          }
          if (!snapshot.hasData) {
            return Container();
          }

          if (snapshot.data.length > 0) {
            return SearchLinkListWidget(list: snapshot.data);
          } else {
            return Container();
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
}
