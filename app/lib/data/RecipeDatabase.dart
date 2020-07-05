import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:foodplan/model/recipe.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class RecipeDatabase {
  static final RecipeDatabase db = RecipeDatabase._init();
  static Database _db;

  RecipeDatabase._init();

  Future<Database> get database async {
    if (_db != null) return _db;

    // if _database is null we instantiate it
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "foodplan_recipe.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE recipe ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT"
          ")");
    });
  }

  newRecipe(Recipe newRecipe) async {
    final db = await database;
    var res = await db.insert("recipe", newRecipe.toMap());
    return res;
  }

  getAllRecipes() async {
    final db = await database;
    var res = await db.query("recipe");
    List<Recipe> list =
        res.isNotEmpty ? res.map((c) => Recipe.fromMap(c)).toList() : [];
    return list;
  }

  deleteRecipe(int id) async {
    final db = await database;
    return db.delete("recipe", where: "id = ?", whereArgs: [id]);
  }
}
