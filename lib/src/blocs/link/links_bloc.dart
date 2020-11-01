import 'dart:convert';

import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/models/search_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:rxdart/rxdart.dart';

class LinksBloc {
  final _repository = new Repository();
  final _fetchLinks = BehaviorSubject<List<LinkModel>>();
  final _searchLinks = BehaviorSubject<List<SearchLinkModel>>();

  // Stream
  Observable<List<LinkModel>> get links => _fetchLinks.stream;
  Observable<List<SearchLinkModel>> get search => _searchLinks.stream;

  fetchLinks() async {
    try {
      final ids = await _repository.fetchAllLinks();
      _fetchLinks.sink.add(ids);
    } catch (e) {
      if(JsonUtils.isValidJSONString(e.toString())){
        _fetchLinks.sink.addError(json.decode(e.toString())["msg"]);
      }else {
        _fetchLinks.sink.addError("Unexpected server error");
      }

    }
  }

  searchLinks(String word) async {
    try {
      final res = await _repository.searchLink(word);
      _searchLinks.sink.add(res);
    } catch (e) {
      if(JsonUtils.isValidJSONString(e.toString())){
        _searchLinks.sink.addError(json.decode(e.toString())["msg"]);
      }else {
        _searchLinks.sink.addError("Unexpected server error");
      }

    }
  }

  clearCache() {
    return _repository.clearLinkCache();
  }

  dispose() {
    _fetchLinks.close();
    _searchLinks.close();

  }
  disposeSearch() {
    _searchLinks.close();
  }

  resetSearch(){
      _searchLinks.add([]);
  }
}
