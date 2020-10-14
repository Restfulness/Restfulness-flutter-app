import 'package:flutter/cupertino.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:restfulness/src/resources/authorization_api_provider.dart';

import 'authorization_db_provider.dart';

class Repository {
  Future _doneFuture;
  AuthorizationApiProvider apiProvider = new AuthorizationApiProvider();

  List<Source> sources = <Source>[
    authorizationDbProvide,
    AuthorizationApiProvider(),
  ];

  List<Cache> caches = <Cache>[authorizationDbProvide];

  Repository(BuildContext context) {
    _doneFuture = authorizationDbProvide.init();
    apiProvider.setAppUrl(context);
  }

  Future<UserModel> login(String username, String password) async {
    UserModel user;

    var source;
    for (source in sources) {
      user = await source.login(username, password);
      if (user != null) {
        break;
      }
    }

    for (Cache cache in caches) {
      if (cache != source && user !=
          null) { // TODO check http response in AuthorizationApiProvider to handling exception(should remove user != null )
        cache.addUser(user);
      }
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
