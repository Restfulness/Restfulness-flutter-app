import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<LinkListWidgetState> _key = GlobalKey();
  TextEditingController addLinkController;
  int _state = 0;

  bool isShowPreview = true;

  @override
  void initState() {
    super.initState();
    addLinkController = new TextEditingController();

    _readPreviewSwitch().then((value) {
      isShowPreview = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);
    return Column(
      children: [
        buildAddBar(),
        Expanded(
          child: buildList(bloc),
        ),
      ],
    );
  }

  Widget buildAddBar() {
    final bloc = LinksProvider.of(context);

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
                FocusScope.of(context).requestFocus(FocusNode());
                if (addLinkController.text != '') {
                  setState(() {
                    _state = 1;
                  });
                  // temp tag list FIXME: after have separated api for adding tags
                  List<String> tags = new List<String>();
                  tags.add("not tagged");

                  Repository repository = new Repository();
                  await repository.initializationLink;
                  try {
                    final id = await repository.insertLink(
                        tags, _validateUrl(addLinkController.text));
                    if (id != null) {
                      ToastContext(context, "Link successfully added ", true);
                      bloc.resetLinks();
                      bloc.fetchLinks();

                      // get new categories if we have new one
                      final categoriesBloc = CategoriesProvider.of(context);
                      categoriesBloc.fetchCategories();
                    }
                  } catch (e) {
                    if (JsonUtils.isValidJSONString(e.toString())) {
                      ToastContext(
                          context, json.decode(e.toString())["msg"], false);
                    } else {
                      ToastContext(context, "Unexpected server error", false);
                    }
                  }
                }
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
      controller: addLinkController,
      decoration: InputDecoration(
          hintText: 'Add link',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
    );
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

  Widget buildList(LinksBloc bloc) {
    return StreamBuilder(
      stream: bloc.links,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (isShowPreview) {
            return LinkListWidget(key: _key);
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
        if (isShowPreview) {
          _key.currentState.setCardList(snapshot.data);
          return LinkListWidget(key: _key);
        } else {
          return LinkListSimpleWidget(list: snapshot.data);
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
      return 'http://$url';
    }
  }
}
