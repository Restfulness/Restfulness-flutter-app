import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/builder/link_preview.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/models/preview_model.dart';
import 'package:restfulness/src/screens/category_list_screen.dart';
import 'package:restfulness/src/widgets/update_category_widget.dart';

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
                    child: ExtendedImage.network(
                      info.image,
                      fit: BoxFit.cover,
                      cache: true,
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 0.0),
                          child: Text(
                            info.title,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (info.description != '')
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            child: Text(
                              info.description,
                              maxLines: 3,
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
                                    _openOnTagPressed(
                                        context, item.index, bloc);
                                  },
                                  title: category[index].name,
                                  index: index,
                                  activeColor: primaryLightColor,
                                  color: primaryLightColor,
                                  textColor: Colors.white,
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
            Positioned(
              child:  ClipOval(
                child: Material(
                  color: primaryLightColor, // button color
                  child: InkWell(
                    splashColor: secondaryTextColor, // inkwell color
                    child: SizedBox(width: 25, height: 25, child:Icon(
                      MdiIcons.plus,
                      color: Colors.white,
                    )),
                    onTap: () {
                      UpdateCategoryWidget update = new UpdateCategoryWidget();
                      update.updateCategory(context, id, category);
                    },
                  ),
                ),
              ),
              bottom: 5,
              right: 8,
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfoSimple(BuildContext context, LinksBloc bloc) {
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 0.0),
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
                                    _openOnTagPressed(
                                        context, item.index, bloc);
                                  },
                                  title: category[index].name,
                                  index: index,
                                  activeColor: primaryLightColor,
                                  color: primaryLightColor,
                                  textColor: Colors.white,
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
            Positioned(
              child: ButtonTheme(
                minWidth: 0.5,
                height: 0.5,
                child: MaterialButton(
                    onPressed: () {
                      UpdateCategoryWidget update = new UpdateCategoryWidget();
                      update.updateCategory(context, id, category);
                    },
                    elevation: 1,
                    color: primaryLightColor,
                    child: Icon(
                      MdiIcons.plus,
                      color: Colors.white,
                    ),
                    shape: CircleBorder()),
              ),
              bottom: -4,
              right: -8,
            )
          ],
        ),
      ),
    );
  }

  _openOnTagPressed(BuildContext context, int index, LinksBloc bloc) {
    bloc.fetchLinksByCategoryId(category[index].id, firstPage, firstPageSize);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoryListScreen(
                  name: category[index].name,
                  categoryId: category[index].id,
                ))).then((context) {
      bloc.restCategoryList();
    });
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
}
