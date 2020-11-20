import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/extensions/string_extension.dart';
import 'package:restfulness/src/widgets/lists/link_list_widget.dart';
import 'package:restfulness/src/widgets/lists/search_link_list_widget.dart';
import 'package:restfulness/src/widgets/toast_context.dart';

import '../../constants.dart';

class CategoryListScreen extends StatelessWidget {
  final String name;
  final GlobalKey<LinkListWidgetState> _key = GlobalKey();

  CategoryListScreen({this.name});

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: appBarColor,
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          centerTitle: true,
          title: Text(
            name.capitalize(),
            style: TextStyle(color: Colors.black),
          ),
          brightness: Brightness.light,
        ),
        body: buildList(bloc),
      ),
    );
  }

  Widget buildList(LinksBloc bloc) {
    return StreamBuilder(
        stream: bloc.fetchByCategory,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            ToastContext(context,snapshot.error, false);
            return CircularProgressIndicator(
              value: 0,
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return LinkListWidget(key: _key);
          }

          _key.currentState.serCardList(snapshot.data);
          return LinkListWidget(key: _key);
        });
  }
}
