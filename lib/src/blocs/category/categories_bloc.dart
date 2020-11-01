import 'dart:convert';

import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:rxdart/rxdart.dart';

class CategoriesBloc {
  final _repository = new Repository();
  final _fetchCategories = BehaviorSubject<List<CategoryModel>>();

  // Stream
  Observable<List<CategoryModel>> get category => _fetchCategories.stream;

  fetchCategories() async {
    try {
      final cats = await _repository.fetchAllCategories();
      _fetchCategories.sink.add(cats);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _fetchCategories.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _fetchCategories.sink.addError("Unexpected server error");
      }
    }
  }

  dispose() {
    _fetchCategories.close();
  }
}
