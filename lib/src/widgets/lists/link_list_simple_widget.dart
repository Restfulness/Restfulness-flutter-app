import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';

import '../link_simple_widget.dart';

class LinkListSimpleWidget extends StatefulWidget {
  const LinkListSimpleWidget({
    Key key,
    @required this.list,
  }) : super(key: key);

  final List<dynamic> list;

  @override
  _LinkListSimpleWidgetState createState() => _LinkListSimpleWidgetState();
}

class _LinkListSimpleWidgetState extends State<LinkListSimpleWidget> {
  List<dynamic> _list;

  LinksBloc linksBloc;

  @override
  void initState() {
    _list = widget.list;

    super.initState();
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
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, int index) {
        return LinkSimpleWidget(
            id: widget.list[index].id,
            url: widget.list[index].url,
            category: widget.list[index].categories ,
            onDelete: () => removeItem(index));
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
