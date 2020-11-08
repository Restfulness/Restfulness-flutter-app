import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/link_model.dart';

import '../link_preview_widget.dart';

class LinkListWidget extends StatefulWidget {
  const LinkListWidget(
      {Key key, @required this.list,})
      : super(key: key);

  final List<LinkModel> list;

  @override
  _LinkListWidgetState createState() => _LinkListWidgetState();
}

class _LinkListWidgetState extends State<LinkListWidget> {
  List<LinkModel> _list;

  LinksBloc linksBloc;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    linksBloc = LinksProvider.of(context);
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, int index) {
        CircularProgressIndicator(value: 0);
        return LinkPreviewWidget(
          id: widget.list[index].id,
          url: widget.list[index].url,
          category: widget.list[index].categories,
          onDelete: () => removeItem(index),
        );
      },
    );
  }

  void removeItem(int index) {
    setState(() {
      _list = widget.list;
      _list = List.from(_list)..removeAt(index);

      linksBloc.addLinks(_list);
    });
  }

}
