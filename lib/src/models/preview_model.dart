

class PreviewModel {
  String url;
  String title;
  String description;
  String image;
  String appleIcon;
  String favIcon;
  DateTime timeout;

  PreviewModel.fromJson(Map<String, dynamic> parsedJson) {
    url = parsedJson['url'];
    title = parsedJson['title'] ?? '';
    description = parsedJson['description'] ?? '';
    image = parsedJson['image'] ?? '';
    appleIcon = parsedJson['appleIcon'] ?? '';
    favIcon = parsedJson['favIcon'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'title': title ?? '',
      'description': description ?? '',
      'image': image ?? '',
      'appleIcon': appleIcon ?? '',
      'favIcon': favIcon ?? ''
    };
  }
}
