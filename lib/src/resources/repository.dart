import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:restfulness/src/resources/authorization_api_provider.dart';

import 'authorization_db_provider.dart';

class Repository {
  Future _doneFuture;
  AuthorizationApiProvider apiProvider = new AuthorizationApiProvider();

  List<Cache> caches = <Cache>[authorizationDbProvide];

  Repository(BuildContext context) {
    _doneFuture = authorizationDbProvide.init();
    apiProvider.setAppUrl(context);
  }

  Future<UserModel> login(String username, String password) async {
    UserModel user;

    user = await apiProvider.login(username, password);
    if (user != null) {
      caches[0].addUser(user);
    }

    return user;
  }

  Future<UserModel> currentUser() async {
    UserModel user;

    user = await caches[0].currentUser();

    return user;
  }

  clearCache() async {
    for (Cache cache in caches) {
      await cache.clear();
    }
  }

  Future get initialization => _doneFuture;
}

abstract class Source {
  Future<UserModel> login(String username, String password);
}

abstract class Cache {
  Future<UserModel> currentUser();

  Future<int> addUser(UserModel user);

  Future<int> clear();
}
