import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/search_model.dart';

import '../link_preview_widget.dart';

class SearchLinkListWidget extends StatefulWidget {
  const SearchLinkListWidget({
    Key key,
    @required this.list,
  }) : super(key: key);

  final List<SearchLinkModel> list;

  @override
  _SearchLinkListWidgetState createState() => _SearchLinkListWidgetState();
}

class _SearchLinkListWidgetState extends State<SearchLinkListWidget> {
  List<SearchLinkModel> _list;

  LinksBloc linksBloc;

  @override
  void initState() {
    _list = widget.list;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    linksBloc = LinksProvider.of(context);
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, int index) {
        return LinkPreviewWidget(
            id: widget.list[index].id,
            url: widget.list[index].url,
            category: [],
            onDelete: () => removeItem(index));
      },
    );
  }

  void removeItem(int index) {
    setState(() {
      _list = widget.list;
      _list = List.from(_list)..removeAt(index);

      linksBloc.addSearchLinks(_list);
    });
  }
}
