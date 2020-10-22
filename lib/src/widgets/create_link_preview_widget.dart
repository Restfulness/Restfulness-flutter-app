import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';

class CreateLinkPreviewWidget extends StatelessWidget {
  final int id;
  final String url;
  final List<dynamic> category;


  CreateLinkPreviewWidget({this.id, this.url, this.category});

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);

    return FlutterLinkPreview(
      url: url,
      bodyStyle: TextStyle(
        fontSize: 18.0,
      ),
      titleStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      builder: (info) {
        if (info is WebInfo) {
          return buildWebInfo(info, context, bloc);
        }
        if (info is WebImageInfo) {
          return buildWebImageInfo(info);
        } else if (info is WebVideoInfo) {
          return buildWebVideoInfo(info);
        }
        return Container();
      },
    );
  }

  Widget buildWebInfo(WebInfo info, BuildContext context, LinksBloc bloc) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (info.image != null)
              Expanded(
                  child: Image.network(
                    info.image,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  )),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Text(
                info.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (info.description != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(info.description),
              ),
          ],
        ),
        Positioned(
          child: Tags(
            itemCount: category.length,
            itemBuilder: (int index) {
              return Tooltip(
                  message: category[index],
                  child: ItemTags(
                    title: category[index],
                    index: index,
                  )
              );
            },
          ),
          top: 10,
          left: 10,
        ),
            Positioned(
              child: ButtonTheme(
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
                        showSnackBar(context, "Deleted successfully", true);
                        bloc.fetchLinks();
                      }
                    } catch (e) {
                      if(JsonUtils.isValidJSONString(e.toString())){
                        showSnackBar(context, json.decode(e.toString())["msg"] , false);
                      }else {
                        showSnackBar(context, "Unexpected server error ", false);
                      }
                    }
                  },
                ),
              ),
              right: 1,
            ),
        ],
      ),
    ),);
  }

  Widget buildWebImageInfo(WebImageInfo info) {
    return SizedBox(
      height: 250,
      child: Card(
          elevation: 6,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          clipBehavior: Clip.antiAlias,
          child: Stack(children: [
            Image.network(
              info.image,
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ])),
    );
  }

  Widget buildWebVideoInfo(WebVideoInfo info) {
    return SizedBox(
      height: 250,
      child: Card(
          elevation: 6,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          clipBehavior: Clip.antiAlias,
          child: Stack(children: [
            Image.network(
              info.image,
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          ])),
    );
  }

  void showSnackBar(BuildContext context, String message , bool isSuccess) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Row(
          children: [
            isSuccess? Icon(Icons.check_circle, color: Colors.green): Icon(Icons.error, color: Colors.red),
            SizedBox(width: 10.0),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 2)));
  }
}
