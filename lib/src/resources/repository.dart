import 'package:flutter/material.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/models/search_model.dart';
import 'package:restfulness/src/models/social_model.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:restfulness/src/resources/authorization_api_provider.dart';
import 'package:restfulness/src/resources/category_api_provider.dart';
import 'package:restfulness/src/resources/category_db_provider.dart';
import 'package:restfulness/src/resources/link_api_provider.dart';
import 'package:restfulness/src/resources/profile_api_provider.dart';
import 'package:restfulness/src/resources/reset_password_api_provider.dart';
import 'package:restfulness/src/resources/social_api_provider.dart';

import 'authorization_db_provider.dart';
import 'link_db_provider.dart';

class Repository {
  Future _doneInitForAuth;
  Future _doneInitForLinks;
  Future _doneInitForCategories;

  AuthorizationApiProvider authApiProvider = new AuthorizationApiProvider();
  LinkApiProvider linkApiProvider = new LinkApiProvider();
  CategoryApiProvider categoryApiProvider = new CategoryApiProvider();
  ResetPasswordApiProvider resetPasswordApiProvider =
      new ResetPasswordApiProvider();
  SocialApiProvider socialApiProvider = new SocialApiProvider();
  ProfileApiProvider profileApiProvider = new ProfileApiProvider();

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

  Future<bool> fetchPublicLinksSetting() async {
    UserModel user = await authorizationDbProvider.currentUser();

    final public = await profileApiProvider.fetchPublicLinksSetting(
        token: user.accessToken);

    return public;
  }

  Future<String> updatePublicLinksSetting(bool public) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final msg = await profileApiProvider.updatePublicLinksSetting(
        token: user.accessToken, public: public);
    return msg;
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

  Future<List<LinkModel>> fetchAllLinks(int page, int pageSize) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links = linkSources[1]
        .fetchAllLinks(token: user.accessToken, page: page, pageSize: pageSize);

    return links;
  }

  Future<LinkModel> fetchLink(int id) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final link = linkSources[1].fetchLink(id: id, token: user.accessToken);

    return link;
  }

  Future<List<LinkModel>> fetchSocialUsersLinks(
      {@required int id, DateTime date, int page, int pageSize}) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links = linkSources[1]
        .fetchSocialUsersLinks(token: user.accessToken, id: id, date: date,page: page,pageSize: pageSize);

    return links;
  }

  Future<bool> deleteLink(int id) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links = linkSources[1].deleteLink(token: user.accessToken, id: id);

    return links;
  }

  Future<List<SearchLinkModel>> searchLink(
      String word, int page, int pageSize) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links = linkSources[1].searchLink(
        token: user.accessToken, word: word, page: page, pageSize: pageSize);

    return links;
  }

  Future<List<SearchLinkModel>> fetchLinkByCategoryId(
      int id, int page, int pageSize) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final links = linkSources[1].fetchLinksByCategoryId(
        token: user.accessToken, id: id, page: page, pageSize: pageSize);

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

  Future<String> updateCategory(List<String> category, int id) async {
    UserModel user = await authorizationDbProvider.currentUser();
    final categories = linkSources[1].updateLinksCategory(
        token: user.accessToken, id: id, category: category);

    return categories;
  }

  clearCategoryCache() async {
    await categoryDbProvider.clear();
  }

  Future<String> forgotPass(String email) async {
    String hash = await resetPasswordApiProvider.forgotPass(email: email);

    return hash;
  }

  Future<String> verifyCode(String hashData, int code) async {
    String hash =
        await resetPasswordApiProvider.verifyCode(hash: hashData, code: code);

    return hash;
  }

  Future<String> resetPass(String token, String newPass) async {
    String msg = await resetPasswordApiProvider.resetPass(
        token: token, newPass: newPass);
    return msg;
  }

  Future<List<SocialModel>> social(
      DateTime date, int page, int pageSize) async {
    UserModel user = await authorizationDbProvider.currentUser();
    List<SocialModel> otherUserLinks = await socialApiProvider.fetchSocial(
        token: user.accessToken, date: date, page: page, pageSize: pageSize);
    return otherUserLinks;
  }

  Future get initializationAuth => _doneInitForAuth;

  Future get initializationLink => _doneInitForLinks;

  Future get initializationCategory => _doneInitForCategories;
}

abstract class UserSource {
  Future<UserModel> login(String username, String password);
}

abstract class ProfileSource {
  Future<bool> fetchPublicLinksSetting({@required String token});

  Future<String> updatePublicLinksSetting(
      {@required String token, bool public});
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

  Future<List<LinkModel>> fetchAllLinks(
      {@required String token, int page, int pageSize});

  Future<LinkModel> fetchLink({@required int id, String token});

  Future<List<SearchLinkModel>> searchLink(
      {@required String token,
      String word,
      int page,
      int pageSize}); // FIXME: refactor to LinkModel after api changed to standard model

  Future<List<SearchLinkModel>> fetchLinksByCategoryId(
      {@required String token,
      int id,
      int page,
      int pageSize}); // FIXME: refactor to LinkModel after api changed to standard model

  Future<String> updateLinksCategory(
      {List<String> category, int id, @required String token});

  Future<List<LinkModel>> fetchSocialUsersLinks(
      {@required int id, @required String token, DateTime date, int page, int pageSize});
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
