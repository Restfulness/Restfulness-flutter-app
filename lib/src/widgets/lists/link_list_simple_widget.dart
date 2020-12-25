import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/screens/home_screen.dart';

import '../../../constants.dart';
import '../link_simple_widget.dart';

class LinkListSimpleWidget extends StatefulWidget {
  const LinkListSimpleWidget(
      {Key key, @required this.screenName, this.categoryId})
      : super(key: key);

  final int categoryId;
  final Type screenName;

  @override
  LinkListSimpleWidgetState createState() => LinkListSimpleWidgetState();
}

class LinkListSimpleWidgetState extends State<LinkListSimpleWidget> {
  List<dynamic> _list = new List<dynamic>();

  LinksBloc linksBloc;

  ScrollController _controller;

  int page;
  int pageSize;

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
    print(_list.length);
    return ListView.builder(
      controller: _controller,
      itemCount: _list.length,
      itemBuilder: (context, int index) {
        return LinkSimpleWidget(
            id: _list[index].id,
            url: _list[index].url,
            category: _list[index].categories,
            onDelete: () => removeItem(index));
      },
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        page += 1;
      });

      if (widget.screenName == HomeScreenState) {
        linksBloc.fetchLinks(page, pageSize);
      } else {
        linksBloc.fetchLinksByCategoryId(widget.categoryId, page, pageSize);
      }
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }

  void removeItem(int index) {
    setState(() {
      _list = List.from(_list)..removeAt(index);

      linksBloc.addLinks(_list);
    });
  }
}
