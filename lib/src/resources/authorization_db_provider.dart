import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restfulness/src/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

import 'repository.dart';

class AuthorizationDBProvider implements UserCache {
  Database db;

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, "user.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
        CREATE TABLE User
        (
         id INTEGER PRIMARY KEY,
         username TEXT,
         password TEXT,
         accessToken TEXT
        )
        """);
    });
    return db;
  }

  Future<UserModel> currentUser() async {
    print("query $db");
    final maps = await db.query(
      "User",
      columns: null,
      where: "id = ?",
      whereArgs: [1],
    );

    if (maps.length > 0) {
      return UserModel.fromDB(maps.first);
    }
    return null;
  }

  Future<int> addUser(UserModel userModel) {
    //TODO hash password before saving
    return db.insert("User", userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> updateToken(String username, String token) async {
    Map<String, dynamic> row = {
      'accessToken': token,
    };

    int updateCount = await db
        .update("User", row, where: "username = ?", whereArgs: [username]);

    return updateCount;
  }

  Future<int> clear() {
    return db.delete("User");
  }
}

final authorizationDbProvider = new AuthorizationDBProvider();
