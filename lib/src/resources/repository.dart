import 'package:flutter/cupertino.dart';
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

  Repository(BuildContext context) {
    _doneInitForAuth = authorizationDbProvider.init();
    _doneInitForLinks = linkDbProvide.init();

    authApiProvider.init(context);
    linkApiProvider.init(context);
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

  Future<LinkModel> insertLink(List <String> category, String url) async {
    LinkModel link;
    UserModel user = await authorizationDbProvider.currentUser();
    link = await linkSources[1].insertLink(category, url, user.accessToken);
    if (link != null) {
      linkCaches[0].addLink(link);
    }

    return link;
  }

  Future<List<int>> fetchAllLinks() {
    return linkSources[1].fetchAllLinks();
  }

  Future<LinkModel> fetchLink(int id) async {
    LinkModel link;
    var source;
    for (source in linkSources) {
      link = await source.fetchLink(id);
      if (link != null) {
        break;
      }
    }
    for (LinkCache cache in linkCaches) {
      if (cache != source) {
        // check if its exist in db or not .
        cache.addLink(link);
      }
    }
    return link;
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
  Future<LinkModel> insertLink(List <String> category, String url, String token);

  Future<List<int>> fetchAllLinks();

  Future<LinkModel> fetchLink(int id);
}

abstract class LinkCache {
  Future<int> addLink(LinkModel linkModel);

  Future<int> clear();
}
