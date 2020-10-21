import 'package:flutter/material.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:restfulness/src/resources/authorization_api_provider.dart';
import 'package:restfulness/src/resources/link_api_provider.dart';

import 'authorization_db_provider.dart';
import 'link_db_provider.dart';

class Repository {
  Future _doneInitForAuth;
  Future _doneInitForLinks;

  AuthorizationApiProvider authApiProvider = new AuthorizationApiProvider();
  LinkApiProvider linkApiProvider = new LinkApiProvider();

  List<LinkSource> linkSources = <LinkSource>[
    linkDbProvide,
    LinkApiProvider(),
  ];
  List<LinkCache> linkCaches = <LinkCache>[linkDbProvide];

  Repository() {
    _doneInitForAuth = authorizationDbProvider.init();
    _doneInitForLinks = linkDbProvide.init();
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

  Future<LinkModel> insertLink(List<String> category, String url) async {
    LinkModel link;
    UserModel user = await authorizationDbProvider.currentUser();
    link = await linkSources[1]
        .insertLink(category: category, url: url, token: user.accessToken);

    return link;
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

  clearLinkCache() async {
    await linkDbProvide.clear();
  }

  Future get initializationAuth => _doneInitForAuth;

  Future get initializationLink => _doneInitForLinks;
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
  Future<LinkModel> insertLink(
      {List<String> category, String url, @required String token});

  Future<List<LinkModel>> fetchAllLinks({@required String token});

  Future<LinkModel> fetchLink({@required int id, String token});
}

abstract class LinkCache {
  Future<int> addLink(LinkModel linkModel);

  Future<int> clear();
}
