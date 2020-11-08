import 'package:flutter/material.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/models/search_model.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:restfulness/src/resources/authorization_api_provider.dart';
import 'package:restfulness/src/resources/category_api_provider.dart';
import 'package:restfulness/src/resources/category_db_provider.dart';
import 'package:restfulness/src/resources/link_api_provider.dart';

import 'authorization_db_provider.dart';
import 'link_db_provider.dart';

class Repository {
  Future _doneInitForAuth;
  Future _doneInitForLinks;
  Future _doneInitForCategories;

  AuthorizationApiProvider authApiProvider = new AuthorizationApiProvider();
  LinkApiProvider linkApiProvider = new LinkApiProvider();
  CategoryApiProvider categoryApiProvider = new CategoryApiProvider();

  List<LinkSource> linkSources = <LinkSource>[
    linkDbProvide,
    LinkApiProvider(),
  ];
  List<LinkCache> linkCaches = <LinkCache>[linkDbProvide];

  List<CategorySource> categorySources = <CategorySource>[
    categoryDbProvider,
    CategoryApiProvider(),
  ];

  Repository() {
    _doneInitForAuth = authorizationDbProvider.init();
    _doneInitForLinks = linkDbProvide.init();
    _doneInitForCategories = categoryDbProvider.init();
  }

  Future<UserModel> login(String username, String password) async {
    UserModel user;

    user = await authApiProvider.login(username, password);
    if (user != null) {
      authorizationDbProvider.addUser(user);
    }

    return user;
  }

  Future<UserModel> currentUser() async {
    UserModel user;

    user = await authorizationDbProvider.currentUser();

    return user;
  }

  clearUserCache() async {
    await authorizationDbProvider.clear();
  }

  Future<int> insertLink(List<String> category, String url) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final id = await linkSources[1]
        .insertLink(category: category, url: url, token: user.accessToken);

    return id;
  }

  Future<List<LinkModel>> fetchAllLinks() async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links = linkSources[1].fetchAllLinks(token: user.accessToken);

    return links;
  }

  Future<LinkModel> fetchLink(int id) async {
    LinkModel link;

    final formLocal = await linkDbProvide.fetchLink(id: id);
    if (formLocal != null) {
      link = formLocal;
    } else {
      UserModel user = await authorizationDbProvider.currentUser();
      final fromServer =
          await linkApiProvider.fetchLink(id: id, token: user.accessToken);
      link = fromServer;
      linkDbProvide.addLink(link);
    }

    return link;
  }

  Future<bool> deleteLink(int id) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links = linkSources[1].deleteLink(token: user.accessToken, id: id);

    return links;
  }

  Future<List<SearchLinkModel>> searchLink(String word) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links =
        linkSources[1].searchLink(token: user.accessToken, word: word);

    return links;
  }

  Future<List<SearchLinkModel>> fetchLinkByCategoryId(int id) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links =
        linkSources[1].fetchLinksByCategoryId(token: user.accessToken, id: id);

    return links;
  }

  clearLinkCache() async {
    await linkDbProvide.clear();
  }

  Future<List<CategoryModel>> fetchAllCategories() async {
    UserModel user = await authorizationDbProvider.currentUser();
    final categories =
        categorySources[1].fetchAllCategories(token: user.accessToken);

    return categories;
  }

  clearCategoryCache() async {
    await categoryDbProvider.clear();
  }

  Future get initializationAuth => _doneInitForAuth;

  Future get initializationLink => _doneInitForLinks;

  Future get initializationCategory => _doneInitForCategories;
}

abstract class UserSource {
  Future<UserModel> login(String username, String password);
}

abstract class UserCache {
  Future<UserModel> currentUser();

  Future<int> addUser(UserModel user);

  Future<int> clear();
}

abstract class LinkSource {
  Future<int> insertLink(
      {List<String> category, String url, @required String token});

  Future<bool> deleteLink({@required String token, int id});

  Future<List<LinkModel>> fetchAllLinks({@required String token});

  Future<LinkModel> fetchLink({@required int id, String token});

  Future<List<SearchLinkModel>> searchLink(
      {@required String token,
      String
          word}); // FIXME: refactor to LinkModel after api changed to standard model

  Future<List<SearchLinkModel>> fetchLinksByCategoryId(
      {@required String token,
      int id}); // FIXME: refactor to LinkModel after api changed to standard model
}

abstract class LinkCache {
  Future<int> addLink(LinkModel linkModel);

  Future<int> clear();
}

abstract class CategorySource {
  Future<List<CategoryModel>> fetchAllCategories({@required String token});
}

abstract class CategoryCache {
  Future<int> addCategory(CategoryModel categoryModel);

  Future<int> clear();
}
