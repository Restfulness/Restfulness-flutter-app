import 'dart:convert';

import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:rxdart/rxdart.dart';

class LinksBloc {
  final _repository = new Repository();
  final _fetchLinks = BehaviorSubject<List<LinkModel>>();

  // Stream
  Observable<List<LinkModel>> get links => _fetchLinks.stream;
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

  clearCache() {
    return _repository.clearLinkCache();
  }

  dispose() {
    _fetchLinks.close();

  }
}
