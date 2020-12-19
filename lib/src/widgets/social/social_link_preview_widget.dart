import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/builder/link_preview.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/models/preview_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinkPreviewWidget extends StatelessWidget {
  final String url;
  final int id;
  final List<CategoryModel> category;


  SocialLinkPreviewWidget({this.id, this.url, this.category});

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
      child:InkWell(
        onTap: () => {
          _launchURL()
        },
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
          ],
        ),
      ),),
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
          ],
        ),
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


  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
