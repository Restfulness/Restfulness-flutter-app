import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:restfulness/src/widgets/menu/simple_menu.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkSimpleWidget extends StatelessWidget {
  final String url;
  final int id;
  final List<CategoryModel> category;
  final VoidCallback onDelete;

  LinkSimpleWidget({this.id, this.url, this.category, this.onDelete});

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.85;

    return Container(
      height: 80,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            buildInfo(context),
            Positioned(
              child: Container(
                  child: SimpleMenu(
                icons: [
                  Icon(MdiIcons.shareVariantOutline ,size: 15,),
                  Icon(MdiIcons.trashCanOutline ,size: 15,),
                  Icon(MdiIcons.openInApp ,size: 15,),
                ],
                backgroundColor: primaryColor,
                borderRadius: BorderRadius.circular(8),
                iconColor: Colors.white,
                onChange: (index) {
                  if (index == 0) {
                    _shareLink(context);
                  } else if (index == 1) {
                    deleteLink(context).then((response) {
                      if (response) {
                        final bloc = LinksProvider.of(context);
                        bloc.resetLinks();
                        bloc.fetchLinks();
                        ToastContext(context, "Deleted successfully", true);
                        // reset category list
                        final categoryBloc = CategoriesProvider.of(context);
                        categoryBloc.fetchCategories();
                      }
                    });
                  } else {
                    _launchURL();
                  }
                },
              )),
              top: 12,
              right: 8,
            )
          ],
        ),
      ),
    );
  }


  Widget buildInfo( BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.85;
    return  Stack(
          children: [
            Row(
              children: [
                Container(
                  width: cWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 14.0, 12.0, 0.0),
                          child: Text(
                            url,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
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
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
    );
  }

  _shareLink(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    Share.share(url,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<bool> deleteLink(BuildContext context) async {
    try {
      Repository repository = new Repository();
      final response = await repository.deleteLink(id);

      return response;
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        ToastContext(context, json.decode(e.toString())["msg"], false);
      } else {
        ToastContext(context, "Unexpected server error", false);
      }
    }
    return false;
  }

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
