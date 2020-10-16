import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restfulness/src/models/link_model.dart';
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
  Future<LinkModel> fetchLink(int id) async {
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

  Future<List<int>> fetchTopIds() {
    return null;
  }

  @override
  Future<LinkModel> insertLink(List <String> category, String url,String token) {
    return null;
  }

  @override
  Future<List<int>> fetchAllLinks() {
    return null;
  }
}

final linkDbProvide = new LinkDBProvider();