import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/widgets/social/social_link_preview_widget.dart';
import 'package:restfulness/src/widgets/social/social_link_simple_widget.dart';

import '../../../constants.dart';

class SocialUserLinks extends StatefulWidget {
  final String username;
  final bool preview;

  SocialUserLinks({this.username, this.preview});

  SocialUserLinksState createState() => SocialUserLinksState();
}

class SocialUserLinksState extends State<SocialUserLinks> {


  ScrollController _controller;

  LinksBloc linkBloc;

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
            widget.username,
            style: TextStyle(color: Colors.black),
          ),
          brightness: Brightness.light,
        ),
        body: buildBody(bloc),
      ),
    );
  }

  Widget buildBody(LinksBloc bloc) {
    return StreamBuilder(
      stream: bloc.socialLinks,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            LinkModel linkModel = snapshot.data[index];

            if (widget.preview) {
              return SocialLinkPreviewWidget(
                id: linkModel.id,
                url: linkModel.url,
                category: linkModel.categories,
              );
            } else {
              return SocialLinkSimpleWidget(
                id: linkModel.id,
                url: linkModel.url,
                category: linkModel.categories,
              );
            }
          },
        );
      },
    );
  }

  _scrollListener() {

    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {

      setState(() {
        page += 1;
      });


    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }
}
