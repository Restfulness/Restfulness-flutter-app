import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDBProvider implements CategoryCache,CategorySource {
  Database db;

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, "categories.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
        CREATE TABLE Categories
        (
         id INTEGER PRIMARY KEY,
         name TEXT,
        )
        """);
    });
    return db;
  }

  @override
  Future<int> addCategory(CategoryModel categoryModel) {
    return db.insert("Categories", categoryModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<int> clear() {
    return db.delete("Categories");
  }

  @override
  Future<List<CategoryModel>> fetchAllCategories({String token}) {
    return null;
  }
}

final categoryDbProvider = new CategoryDBProvider();
