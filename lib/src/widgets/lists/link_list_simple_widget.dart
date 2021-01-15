import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/screens/home_screen.dart';

import '../../../constants.dart';
import '../link_simple_widget.dart';
import '../search_widget.dart';

class LinkListSimpleWidget extends StatefulWidget {
  const LinkListSimpleWidget(
      {Key key, @required this.screenName, this.categoryId, this.searchWord})
      : super(key: key);

  final int categoryId;
  final Type screenName;
  final String searchWord;

  @override
  LinkListSimpleWidgetState createState() => LinkListSimpleWidgetState();
}

class LinkListSimpleWidgetState extends State<LinkListSimpleWidget> {
  List<dynamic> _list = new List<dynamic>();

  LinksBloc linksBloc;

  ScrollController _controller;

  int page;
  int pageSize;

  bool hasDate = false;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    this.page = firstPage;
    this.pageSize = firstPageSize;
  }

  void setList(List<dynamic> list) {
    _list = list;
  }

  @override
  Widget build(BuildContext context) {
    linksBloc = LinksProvider.of(context);

    checkIfHasData();

    return Column(
      children: [
        Expanded(
          child: buildList(),
          flex: 12,
        ),
        Expanded(
          child: SizedBox(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget buildList() {
    return refresh(
      ListView.builder(
        controller: _controller,
        itemCount: _list.length + 1,
        itemBuilder: (context, int index) {
          if (index < _list.length) {
            return LinkSimpleWidget(
                id: _list[index].id,
                url: _list[index].url,
                category: _list[index].categories,
                onDelete: () => removeItem(index));
          } else if (hasDate && _list.length >= firstPageSize) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (!hasDate && _list.length >= firstPageSize) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: Text('nothing more to load!')),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget refresh(Widget child) {
    if (widget.screenName == HomeScreenState) {
      return RefreshIndicator(
        color: secondaryTextColor,
        child: child,
        onRefresh: () async {
          linksBloc.resetLinks();
          page = 0;
          await linksBloc.fetchLinks(firstPage, firstPageSize);
        },
      );
    } else {
      return child;
    }
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page += 1;
      });

      if (widget.screenName == HomeScreenState) {
        linksBloc.fetchLinks(page, pageSize);
      } else if (widget.screenName == SearchWidgetState) {
        linksBloc.searchLinks(widget.searchWord, page, pageSize);
      } else {
        linksBloc.fetchLinksByCategoryId(widget.categoryId, page, pageSize);
      }
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }

  checkIfHasData() {
    if (widget.screenName == HomeScreenState) {
      hasDate = linksBloc.isUserHasData;
    } else if (widget.screenName == SearchWidgetState) {
      hasDate = linksBloc.isSearchHasDate;
    } else {
      hasDate = linksBloc.isCategoryHasDate;
    }
  }

  void removeItem(int index) {
    setState(() {
      _list = List.from(_list)..removeAt(index);

      linksBloc.addLinks(_list);
    });
  }
}
