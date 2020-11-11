import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/builder/link_preview.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/models/preview_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreviewWidget extends StatelessWidget {
  final String url;
  final int id;
  final List<CategoryModel> category;
  final VoidCallback onDelete;

  LinkPreviewWidget({this.id, this.url, this.category, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);
    return LinkPreview(
      url: url,
      builder: (info) {
        if (info != null) {
          if (info.title == '') {
            return buildInfoSimple(context, bloc);
          }
          return buildInfo(info, context, bloc);
        } else {
          return buildLoading();
        }
      },
    );
  }

  Widget buildInfo(PreviewModel info, BuildContext context, LinksBloc bloc) {
    double cWidth = MediaQuery.of(context).size.width * 0.55;

    return Container(
      height: 120,
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Row(
              children: [
                if (info.image != '')
                  Container(
                    width: 120,
                    height: double.infinity,
                    child: Image.network(
                      info.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (info.image == '')
                  Container(
                    width: 120,
                    height: double.infinity,
                    child: Image.asset(
                      "assets/images/default.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                Container(
                  width: cWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 5.0),
                        child: Text(
                          info.title,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (info.description != '')
                        Padding(
                          padding: EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 6.0),
                          child: Text(
                            info.description,
                            maxLines: 3,
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 1.0, 12.0, 1.0),
                        child: Tags(
                          heightHorizontalScroll: 30,
                          horizontalScroll: true,
                          itemCount: category.length,
                          itemBuilder: (int index) {
                            return Tooltip(
                              message: category[index].name,
                              child: ItemTags(
                                onPressed: (item) {
                                  print('${category[item.index].id}');
                                },
                                title: category[index].name,
                                index: index,
                                activeColor: primaryLightColor,
                                textStyle: TextStyle(fontSize: 12),
                                elevation: 1,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            // Positioned(
            //   child: Column(
            //     children: [
            //       buildDeleteButton(context, bloc),
            //       buildShareButton(context),
            //       buildOpenButton()
            //     ],
            //   ),
            //   right: 1,
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoSimple(BuildContext context, LinksBloc bloc) {
    double cWidth = MediaQuery.of(context).size.width * 0.55;

    return Container(
      height: 120,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(children: [
          Row(
            children: [
              Container(
                width: 120,
                height: double.infinity,
                child: Image.asset(
                  "assets/images/default.png",
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Container(
              width: cWidth,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 5.0),
                    child: Text(
                      url,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 1.0, 12.0, 1.0),
                    child: Tags(
                      heightHorizontalScroll: 30,
                      horizontalScroll: true,
                      itemCount: category.length,
                      itemBuilder: (int index) {
                        return Tooltip(
                          message: category[index].name,
                          child: ItemTags(
                            onPressed: (item) {
                              print('${category[item.index].id}');
                            },
                            title: category[index].name,
                            index: index,
                            activeColor: primaryLightColor,
                            textStyle: TextStyle(fontSize: 12),
                            elevation: 1,
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
        ]),
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      height: 120,
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget buildDeleteButton(BuildContext context, LinksBloc bloc) {
    return ButtonTheme(
      minWidth: 1,
      height: 40.0,
      child: FlatButton(
        child: Icon(
          MdiIcons.trashCanOutline,
          color: Colors.red,
        ),
        shape: CircleBorder(),
        color: Colors.white,
        onPressed: () async {
          try {
            Repository repository = new Repository();
            final response = await repository.deleteLink(id);
            if (response) {
              _showSnackBar(context, "Deleted successfully", true);
              onDelete();
              bloc.fetchLinks();
              // reset category list
              final categoryBloc = CategoriesProvider.of(context);
              categoryBloc.fetchCategories();
            }
          } catch (e) {
            if (JsonUtils.isValidJSONString(e.toString())) {
              _showSnackBar(context, json.decode(e.toString())["msg"], false);
            } else {
              _showSnackBar(context, "Unexpected server error ", false);
            }
          }
        },
      ),
    );
  }

  Widget buildShareButton(BuildContext context) {
    return ButtonTheme(
      minWidth: 1,
      height: 40.0,
      child: FlatButton(
        child: Icon(
          MdiIcons.shareVariantOutline,
          color: Colors.blue,
        ),
        shape: CircleBorder(),
        color: Colors.white,
        onPressed: () async {
          final RenderBox box = context.findRenderObject();
          Share.share(url,
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        },
      ),
    );
  }

  Widget buildOpenButton() {
    return ButtonTheme(
      minWidth: 1,
      height: 40.0,
      child: FlatButton(
        child: Icon(
          MdiIcons.openInApp,
          color: Colors.orange,
        ),
        shape: CircleBorder(),
        color: Colors.white,
        onPressed: () {
          _launchURL();
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, bool isSuccess) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Row(
          children: [
            isSuccess
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.error, color: Colors.red),
            SizedBox(width: 10.0),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 2)));
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
