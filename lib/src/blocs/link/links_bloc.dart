import 'dart:convert';

import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/models/search_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';

class LinksBloc {
  final _repository = new Repository();
  final _fetchLinks = BehaviorSubject<List<LinkModel>>();
  final _fetchSocialUsersLinks = BehaviorSubject<List<LinkModel>>();
  final _searchLinks = BehaviorSubject<List<SearchLinkModel>>();

  final _fetchLinksByCategory = BehaviorSubject<List<SearchLinkModel>>();

  // Stream
  Observable<List<LinkModel>> get links => _fetchLinks.stream;

  Observable<List<LinkModel>> get socialLinks => _fetchSocialUsersLinks.stream;

  Observable<List<SearchLinkModel>> get search => _searchLinks.stream;

  Observable<List<SearchLinkModel>> get fetchByCategory =>
      _fetchLinksByCategory.stream;

  // Sink
  Function(List<LinkModel>) get addLinks => _fetchLinks.sink.add;

  Function(List<SearchLinkModel>) get addSearchLinks => _searchLinks.sink.add;

  Function(List<SearchLinkModel>) get addCategoryById =>
      _fetchLinksByCategory.sink.add;

  List<LinkModel> savedListCard = new List();

  fetchLinks(int page, int pageSize) async {
    try {
      final ids = await _repository.fetchAllLinks(page, pageSize);

      ids.forEach((element) {
        if ((savedListCard.singleWhere((link) => link.id == element.id,
                orElse: () => null)) ==
            null) {
          savedListCard.add(element);
        }
      });

      _fetchLinks.sink.add(savedListCard);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _fetchLinks.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _fetchLinks.sink.addError("Unexpected server error");
      }
    }
  }

  fetchLinkById(int id) async {

    try {
      final link = await _repository.fetchLink(id);

      savedListCard.insert(0, link);

      _fetchLinks.sink.add(savedListCard);
    } catch (e) {
      print(e.toString());
      if (JsonUtils.isValidJSONString(e.toString())) {
        _fetchLinks.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _fetchLinks.sink.addError("Unexpected server error");
      }
    }
  }

  updateLink(int id) async {

    int linkIndex = savedListCard.indexWhere((item) => item.id == id);

    try {
      final link = await _repository.fetchLink(id);

      savedListCard[linkIndex] = link;

      _fetchLinks.sink.add(savedListCard);
    } catch (e) {
      print(e.toString());
      if (JsonUtils.isValidJSONString(e.toString())) {
        _fetchLinks.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _fetchLinks.sink.addError("Unexpected server error");
      }
    }


  }

  fetchSocialUserLinks(int id, DateTime date) async {
    try {
      final ids = await _repository.fetchSocialUsersLinks(id: id, date: date);
      _fetchSocialUsersLinks.sink.add(ids);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _fetchSocialUsersLinks.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _fetchSocialUsersLinks.sink.addError("Unexpected server error");
      }
    }
  }

  fetchLinksByCategoryId(int id) async {
    try {
      final res = await _repository.fetchLinkByCategoryId(
          id); // FIXME: first get from db and then if that id not exists inside db, fetch that id from api
      _fetchLinksByCategory.sink.add(res);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _fetchLinksByCategory.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _fetchLinksByCategory.sink.addError("Unexpected server error");
      }
    }
  }

  searchLinks(String word) async {
    try {
      final res = await _repository.searchLink(word);
      _searchLinks.sink.add(res);
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        _searchLinks.sink.addError(json.decode(e.toString())["msg"]);
      } else {
        _searchLinks.sink.addError("Unexpected server error");
      }
    }
  }

  clearCache() {
    return _repository.clearLinkCache();
  }

  dispose() {
    _fetchLinks.close();
    _fetchSocialUsersLinks.close();
    _searchLinks.close();

    _fetchLinksByCategory.close();
  }

  deleteItemFromLinks(int id) {
    savedListCard.removeWhere((item) => item.id == id);

    _fetchLinks.sink.add(savedListCard);
  }

  refreshLinks() {
    _fetchLinks.sink.add(savedListCard);
  }



  resetLinks() {
    _fetchLinks.add([]);
  }

  resetSearch() {
    _searchLinks.add([]);
  }

  restCategoryList() {
    _fetchLinksByCategory.add([]);
  }

  restSocialList() {
    _fetchSocialUsersLinks.add([]);
  }
}
