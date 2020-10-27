import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:restfulness/src/models/preview_model.dart';

class FetchPreviewHelper {
  static Map<String, PreviewModel> map = {};

  Future<PreviewModel> fetch(url) async {
    PreviewModel previewModel;
    try {
      final client = Client();
      final response = await client.get(_validateUrl(url));
      final document = parse(response.body);

      print("Get web res:${response.statusCode}");
      String description, title, image, appleIcon, favIcon;

      var elements = document.getElementsByTagName('meta');
      final linkElements = document.getElementsByTagName('link');

      elements.forEach((tmp) {
        if (tmp.attributes['property'] == 'og:title') {
          //fetch seo title
          title = tmp.attributes['content'];
        }
        //if seo title is empty then fetch normal title
        if (title == null || title.isEmpty) {
          if (document.getElementsByTagName('title').length > 0) {
            title = document.getElementsByTagName('title')[0].text;
          } else {
            title = "";
          }
        }

        //fetch seo description
        if (tmp.attributes['property'] == 'og:description') {
          description = tmp.attributes['content'];
        }
        //if seo description is empty then fetch normal description.
        if (description == null || description.isEmpty) {
          //fetch base title
          if (tmp.attributes['name'] == 'description') {
            description = tmp.attributes['content'];
          }
        }

        //fetch image
        if (tmp.attributes['property'] == 'og:image') {
          image = tmp.attributes['content'];
        }
      });

      linkElements.forEach((tmp) {
        if (tmp.attributes['rel'] == 'apple-touch-icon') {
          appleIcon = tmp.attributes['href'];
        }
        if (tmp.attributes['rel']?.contains('icon') == true) {
          favIcon = tmp.attributes['href'];
        }
      });
      Map<String, dynamic> toJson = new Map<String, dynamic>();
      toJson['url'] = url;
      toJson['title'] = title;
      toJson['description'] = description;
      toJson['image'] = image;
      toJson['appleIcon'] = appleIcon;
      toJson['favIcon'] = favIcon;

      previewModel = PreviewModel.fromJson(toJson);
      saveInfoToCache(url, previewModel);

      return previewModel;
    } catch (e) {
      Map<String, dynamic> toJson = new Map<String, dynamic>();
      toJson['url'] = url;
      return PreviewModel.fromJson(toJson);
    }
  }

  saveInfoToCache(String url, PreviewModel info) {
    map[url] = info;
  }

  PreviewModel getInfoFromCache(String url) {
    final PreviewModel info = map[url];

    return info;
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
