import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:restfulness/src/widgets/lists/link_list_simple_widget.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../widgets/lists/link_list_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<LinkListWidgetState> _keyPreviewList = GlobalKey();
  final GlobalKey<LinkListSimpleWidgetState> _keySimpleList = GlobalKey();

  TextEditingController addLinkController;
  int _state = 0;

  // receive sharing
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  String _sharedText = '';

  @override
  void initState() {
    super.initState();
    addLinkController = new TextEditingController();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _sharedText = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    ReceiveSharingIntent.reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);
    if (_sharedText != '') {
      addLinkShare(bloc);
      //addLinkController.text = _getUrlFromString(_sharedText);
    }
    return Column(
      children: [
        buildAddBar(),
        Expanded(
          child: getPreviewSetting(bloc),
        ),
      ],
    );
  }

  Widget buildAddBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(11, 15, 0, 15),
              child: Material(
                elevation: 6.0,
                borderRadius: BorderRadius.circular(30),
                child: _buildAddField(context),
              ),
              height: 50,
              width: double.infinity,
            ),
            flex: 4,
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () async {
                addLink();
              },
              elevation: 8.0,
              color: primaryColor,
              child: _buildButtonIcon(),
              padding: EdgeInsets.all(14.0),
              shape: CircleBorder(),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildAddField(BuildContext context) {
    return TextField(
      onChanged: (value) {
        _sharedText = '';
      },
      keyboardType: TextInputType.url,
      controller: addLinkController,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        addLink();
      },
      decoration: InputDecoration(
          hintText: 'Add link',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
    );
  }

  void addLink() async {
    final bloc = LinksProvider.of(context);

    FocusScope.of(context).unfocus();
    if (addLinkController.text != '') {
      setState(() {
        _state = 1;
      });

      List<String> tags = new List<String>();
      tags.add("untagged");

      Repository repository = new Repository();
      await repository.initializationLink;
      try {
        final id = await repository.insertLink(
            tags, _validateUrl(addLinkController.text));
        if (id != null) {
          setState(() {
            addLinkController.clear();
            _sharedText = '';
          });

          bloc.fetchLinkById(id);

          ToastContext(context, "Link successfully added ", true);

          // get new categories if we have new one
          final categoriesBloc = CategoriesProvider.of(context);
          categoriesBloc.fetchCategories();
        }
      } catch (e) {
        if (JsonUtils.isValidJSONString(e.toString())) {
          ToastContext(context, json.decode(e.toString())["msg"], false);
        } else {
          ToastContext(context, "Unexpected server error", false);
        }
      }
    }
  }

  Widget _buildButtonIcon() {
    if (_state == 1) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        //FIXME: shouldn't use delay!
        setState(() {
          _state = 0;
        });
      });
      return SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        height: 25.0,
        width: 25.0,
      );
    } else {
      return Icon(
        MdiIcons.plus,
        color: Colors.white,
      );
    }
  }

  Widget getPreviewSetting(LinksBloc bloc) {
    return FutureBuilder(
        future: _readPreviewSwitch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return buildList(bloc, snapshot.data);
        });
  }

  Widget buildList(LinksBloc bloc, bool isPreview) {
    return StreamBuilder(
      stream: bloc.links,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (isPreview) {
            return LinkListWidget(key: _keyPreviewList ,screenName:
            this.runtimeType);
          } else {
            return LinkListSimpleWidget(key: _keySimpleList,screenName:
            this.runtimeType);
          }
        }
        if (isPreview) {
          _keyPreviewList.currentState.setCardList(snapshot.data);
          return LinkListWidget(key: _keyPreviewList,screenName:
          this.runtimeType);
        } else {
          _keySimpleList.currentState.setList(snapshot.data);
          return LinkListSimpleWidget(key: _keySimpleList,screenName:
          this.runtimeType);
        }
      },
    );
  }

  Future<bool> _readPreviewSwitch() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'preview';
    final value = prefs.getBool(key) ?? true;
    return value;
  }

  _validateUrl(String url) {
    if (url?.startsWith('http://') == true ||
        url?.startsWith('https://') == true) {
      return url;
    } else {
      return 'https://$url';
    }
  }

  void addLinkShare(LinksBloc bloc) async {
    if (_getUrlFromString(_sharedText) != '') {

      List<String> tags = new List<String>();
      tags.add("untagged");

      Repository repository = new Repository();
      await repository.initializationLink;
      try {
        final id = await repository.insertLink(
            tags, _validateUrl(_getUrlFromString(_sharedText)));

        if (id != null) {

          bloc.fetchLinkById(id);

          ToastContext(context, "Link successfully added ", true);

          // get new categories if we have new one
          final categoriesBloc = CategoriesProvider.of(context);
          categoriesBloc.fetchCategories();

        }
      } catch (e) {
        if (JsonUtils.isValidJSONString(e.toString())) {
          ToastContext(context, json.decode(e.toString())["msg"], false);
        } else {
          ToastContext(context, "Unexpected server error", false);
        }
      }
    }
  }

  String _getUrlFromString(String text) {
    if (text != null) {
      final urlRegExp = new RegExp(
          r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
      final urlMatches = urlRegExp.allMatches(text);
      List<String> urls = urlMatches
          .map((urlMatch) => text.substring(urlMatch.start, urlMatch.end))
          .toList();

      return urls[0]; // get first url from text
    }
    return '';
  }
}
