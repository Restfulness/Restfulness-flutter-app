import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/models/search_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';

class LinkDBProvider implements LinkSource, LinkCache {
  Database db;

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, "links.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
        CREATE TABLE Links
        (
         id INTEGER PRIMARY KEY,
         url TEXT,
         categories BLOB
        )
        """);
    });
    return db;
  }

  @override
  Future<LinkModel> fetchLink({@required int id, String token}) async {
    final maps = await db.query(
      "Links",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return LinkModel.fromDB(maps.first);
    }
    return null;
  }

  @override
  Future<int> addLink(LinkModel linkModel) {
    return db.insert("Links", linkModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clear() {
    return db.delete("Links");
  }

  @override
  Future<int> insertLink(
      {List<String> category, String url, @required String token}) {
    return null;
  }

  @override
  Future<List<LinkModel>> fetchAllLinks({@required String token, int page , int pageSize}) {
    return null;
  }

  @override
  Future<bool> deleteLink({String token, int id}) {
    return null;
  }

  @override
  Future<List<SearchLinkModel>> searchLink({String token, String word, int page, int pageSize}) {
    return null;
  }

  @override
  Future<List<SearchLinkModel>> fetchLinksByCategoryId({String token, int id, int page, int pageSize}) {
    return null;
  }

  @override
  Future<String> updateLinksCategory(
      {List<String> category, int id, @required String token}) {
    return null;
  }

  @override
  Future<List<LinkModel>> fetchSocialUsersLinks({int id, String token ,DateTime date}) {
    return null;
  }
}

final linkDbProvide = new LinkDBProvider();
