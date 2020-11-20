
import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/link_model.dart';

import '../widgets/lists/link_list_widget.dart';

class HomeScreen extends StatelessWidget {

  final GlobalKey<LinkListWidgetState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);
    return buildList(bloc);
  }

  Widget buildList(LinksBloc bloc) {
    return StreamBuilder(
        stream: bloc.links,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return LinkListWidget(key: _key);
          }
          _key.currentState.serCardList(snapshot.data);
          return  LinkListWidget(key: _key);
        });
  }

}
