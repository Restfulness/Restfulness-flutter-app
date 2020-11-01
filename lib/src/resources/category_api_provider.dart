
import 'package:restfulness/src/helpers/api_helper.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/resources/repository.dart';

class CategoryApiProvider implements CategorySource{

  ApiHelper apiHelper = ApiHelper();

  @override
  Future<List<CategoryModel>> fetchAllCategories({String token}) async {

    List<CategoryModel> categories = new List<CategoryModel>();

    final response = await apiHelper.get("categories" , headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    for (var cat in response){
      categories.add(CategoryModel.fromJson(cat));
    }

    return categories;
  }



}