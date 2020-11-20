import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/extensions/string_extension.dart';
import 'package:restfulness/src/widgets/lists/search_link_list_widget.dart';

import '../../constants.dart';



class CategoryListScreen extends StatelessWidget {
  final String name;

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
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text(snapshot.error),
                    duration: Duration(seconds: 2))));
            return CircularProgressIndicator(
              value: 0,
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          CircularProgressIndicator(value: 0);
          return SearchLinkListWidget(list: snapshot.data,); //FIXME: refactor to LinkListWidget after api changed to standard model

        });
  }
}
