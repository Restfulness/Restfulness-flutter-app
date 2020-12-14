
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/models/category_model.dart';

class SocialLinkSimpleWidget extends StatelessWidget {

  final String url;
  final int id;
  final List<CategoryModel> category;

  SocialLinkSimpleWidget({this.id, this.url, this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            buildInfo(context),
          ],
        ),
      ),
    );
  }

  Widget buildInfo(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.85;
    return Stack(
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
    );
  }


}
