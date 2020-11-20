import 'category_model.dart';

class SearchModel{
  List<SearchLinkModel> links ;

  SearchModel.fromJson(Map<String, dynamic> parsedJson){
    links = toSearchLinkModel(parsedJson['links']) ?? [];
  }

  List<SearchLinkModel> toSearchLinkModel(links) {
    List<SearchLinkModel> categoryList = new List<SearchLinkModel>();
    for (var cat in links) {
      categoryList.add(SearchLinkModel.fromJson(cat));
    }
    return categoryList;
  }
}

class SearchLinkModel {
  int id ;
  String url;
  List<CategoryModel> categories;

  SearchLinkModel.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['id'];
    url = parsedJson['url'];
    categories = [];
  }
}