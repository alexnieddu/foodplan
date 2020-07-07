import 'package:foodplan/model/Slot.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/model/Slot.dart';
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

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "foodplan_recipe.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE recipe ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "name TEXT"
              ")");
          await db.execute("CREATE TABLE slot ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "name TEXT,"
              "recipe TEXT"
              ")");
          await db.rawInsert("INSERT INTO slot (name, recipe)"
              "VALUES ('Montag', 'Lade zuerst ein Rezept')");
          await db.rawInsert("INSERT INTO slot (name, recipe)"
              "VALUES ('Dienstag', 'Lade zuerst ein Rezept')");
          await db.rawInsert("INSERT INTO slot (name, recipe)"
              "VALUES ('Mittwoch', 'Lade zuerst ein Rezept')");
        });
  }

  Future<int> newRecipe(Recipe newRecipe) async {
    final db = await database;
    var res = await db.insert("recipe", newRecipe.toMap());
    return res;
  }

  Future<List<dynamic>> getAllRecipes() async {
    final db = await database;
    var res = await db.rawQuery("SELECT id, name FROM recipe ORDER BY name ASC");
    List<Recipe> list =
        res.isNotEmpty ? res.map((c) => Recipe.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<dynamic>> getRnd(int recipeID) async {
    final db = await database;
    var res = await db.rawQuery("SELECT name FROM recipe WHERE id != ? ORDER BY RANDOM() LIMIT 1", [recipeID.toString()]);
    List<Recipe> list =
        res.isNotEmpty ? res.map((c) => Recipe.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return db.delete("recipe", where: "id = ?", whereArgs: [id]);
  }



  Future<int> newSlot(Slot newSlot) async {
    final db = await database;
    var res = await db.insert("slot", newSlot.toMap());
    return res;
  }

  Future<List<dynamic>> getAllSlots() async {
    final db = await database;
    var res = await db.rawQuery("SELECT id, name, recipe FROM slot");
    List<Slot> list =
        res.isNotEmpty ? res.map((c) => Slot.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> updateSlot(String recipe, int slotID) async {
    Database db = await database;
    return await db.rawUpdate("UPDATE slot SET recipe = ? WHERE id = ?", [recipe, slotID]);
  }
}
