import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';

class CreateLinkPreviewWidget extends StatelessWidget {
  final String url;
  final String category;

  CreateLinkPreviewWidget({this.url, this.category});

  @override
  Widget build(BuildContext context) {
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
          return buildWebInfo(info);
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

  Widget buildWebInfo(WebInfo info) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 6,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        clipBehavior: Clip.antiAlias,
        child: Column(
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
      ),
    );
  }

  Widget buildWebImageInfo(WebImageInfo info) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 6,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          info.image,
          fit: BoxFit.cover,
          width: double.maxFinite,
        ),
      ),
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
        child: Image.network(
          info.image,
          fit: BoxFit.cover,
          width: double.maxFinite,
        ),
      ),
    );
  }
}
