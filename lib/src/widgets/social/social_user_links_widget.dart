import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/widgets/social/social_link_preview_widget.dart';
import 'package:restfulness/src/widgets/social/social_link_simple_widget.dart';

import '../../../constants.dart';

class SocialUserLinksWidget extends StatefulWidget {
  final int userId;
  final String username;
  final bool preview;

  SocialUserLinksWidget({this.userId, this.username, this.preview});

  SocialUserLinksWidgetState createState() => SocialUserLinksWidgetState();
}

class SocialUserLinksWidgetState extends State<SocialUserLinksWidget> {
  List<dynamic> _list = new List<dynamic>();

  ScrollController _controller;

  LinksBloc linkBloc;

  int page;
  int pageSize;

  @override
  void initState() {
    super.initState();

    _list = [];

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    this.page = firstPage;
    this.pageSize = firstPageSize;
  }

  @override
  Widget build(BuildContext context) {
    linkBloc = LinksProvider.of(context);

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
        body: buildBody(linkBloc),
      ),
    );
  }

  Widget buildBody(LinksBloc bloc) {

    return StreamBuilder(
      stream: bloc.socialLinks,
      builder: (context, snapshot) {
        if (!snapshot.hasData && _list.length == 0) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(snapshot.hasData){
          _list = snapshot.data;
        }
        return ListView.builder(
          controller: _controller,
          itemCount: _list.length,
          itemBuilder: (context, int index) {
            LinkModel linkModel = _list[index];

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
    print('end');
      linkBloc.fetchSocialUserLinks(
          widget.userId, DateTime.now(), page, pageSize);

      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {}
    }
  }
}
