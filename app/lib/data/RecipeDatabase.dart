import 'package:foodplan/model/Slot.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/model/Slot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

List<String> baseRecipes = [
  "Pfannkuchen",
  "Schinkennudeln",
  "Zucchini-Karotten-Nudeln",
  "Gurkensuppe",
  "Schnitzel",
  "Gulasch",
  "Fleischpflanzerl",
  "Pierogi",
  "Ofenkartoffeln",
  "Germknödel",
  "Käsespätzle",
  "Pizzabrötchen",
  "Nudelauflauf",
  "Sauerkrautsuppe",
  "Frischkäse Putenfilet",
  "Kaiserschmarrn",
  "Chili-Sahne-Schnitzel",
  "Bruschetta",
  "Eierflockensuppe",
  "Geschnetzeltes",
  "Cordon Blue",
  "Grießbrei",
  "Steak",
  "Grillen",
  "Strammer Max",
  "Nudelsalat",
  "Tarte",
  "Risotto",
  "Brezenknödel",
  "Tom Kha Gai Suppe",
  "Rouladen",
  "Spaghetti Aglio e Olio",
  "Bolognese",
  "Ofengemüse",
  "Käsesuppe",
  "Rohrnudeln",
  "Gyros",
  "Grillhähnchen",
  "Gemüsesuppe",
  "Lasagne",
  "Gemüselasagne",
  "Lachs-Spinat-Pasta",
  "Lasanki",
  "Pizza",
  "Gefüllte Paprika",
  "Krautwickerl",
  "Salat mit Putenstreifen",
  "Brotzeit",
  "Schweinebraten",
  "Spiegelei",
  "Blätterteig",
  "Dampfnudeln",
  "Weißwürste",
  "Kartoffelsalat",
  "Zucchinisuppe",
  "Fisch in Tomaten-Limette",
  "Strudel",
  "Paprikasuppe",
  "Bratkartoffeln",
  "Schweinefilet",
  "Penne al Forno",
  "Reissuppe",
  "Nudelsuppe",
  "gefüllte Pilze",
  "Gemüse-Wok",
  "Kartoffelsuppe",
  "Fischstäbchen",
  "Kartoffelecken",
  "Kartoffelgratin",
  "Gratin",
  "Currywurst",
  "Pfannkuchensuppe",
  "Kartoffelpuffer",
  "Chicken Wings",
  "überbackene Zucchini",
  "Leberkäse",
  "Milchreis",
  "Spaghetti Carbonara",
  "Zwiebelsuppe",
  "Taccos",
  "Wraps",
  "Chili con Carne",
  "Gnocchi Gorgonzola",
  "Gnocchi Tomaten Sahne",
  "Tomatensuppe",
  "Omlette",
  "gegrillter Fisch",
  "Wiener",
  "Tortellini",
  "Flammkuchen",
  "Thai Curry",
  "Indisches Hähnchen",
  "Backerbsensuppe"
];
List<String> baseSlots = [
  "Montag",
  "Dienstag",
  "Mittwoch",
  "Donnerstag",
  "Freitag",
  "Samstag",
  "Sonntag"
];

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
      // Enable FOREIGN KEYs in SQLite
      await db.execute("PRAGMA foreign_keys = ON;");
      // Create recipe table
      await db.execute("CREATE TABLE recipe ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT"
          ")");
      // Create slot table
      await db.execute("CREATE TABLE slot ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT,"
          "recipeId INTEGER,"
          "FOREIGN KEY (recipeId) REFERENCES recipe(id)"
          ")");
      // TODO: create tables for category and ingredient
      // Insert dummies
      // recipes
      for (String recipe in baseRecipes) {
        await db.rawInsert(
            "INSERT INTO recipe (name)"
            " VALUES (?)",
            [recipe]);
      }
      // slots
      for (String slot in baseSlots) {
        await db.rawInsert(
            "INSERT INTO slot (name, recipeId)"
            " VALUES (?, (SELECT id FROM recipe ORDER BY RANDOM() LIMIT 1))",
            [slot]);
      }
      // TODO: ingredients and categories
    });
  }

  Future<int> newRecipe(Recipe newRecipe) async {
    final db = await database;
    var res = await db.insert("recipe", newRecipe.toMap());
    return res;
  }

  Future<List<dynamic>> getRecipesForSearch(String searchPhrase) async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT id, name FROM recipe ORDER BY name ASC");
    if (searchPhrase.isNotEmpty) {
      res = await db.rawQuery(
          "SELECT id, name FROM recipe WHERE name LIKE ? ORDER BY name ASC",
          ["$searchPhrase%"]);
    }
    List<Recipe> list =
        res.isNotEmpty ? res.map((c) => Recipe.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<dynamic>> getAllRecipes() async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT id, name FROM recipe ORDER BY name ASC");
    List<Recipe> list =
        res.isNotEmpty ? res.map((c) => Recipe.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<dynamic>> getRnd(int recipeID) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT id FROM recipe WHERE id != ? ORDER BY RANDOM() LIMIT 1",
        [recipeID.toString()]);
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
    var res = await db.rawQuery(
        "SELECT slot.id, slot.name, recipe.id AS recipeId, recipe.name AS recipeName FROM slot INNER JOIN recipe ON slot.recipeId = recipe.id");
    List<Slot> list =
        res.isNotEmpty ? res.map((c) => Slot.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> updateSlot(int recipeId, int slotID) async {
    Database db = await database;
    return await db.rawUpdate(
        "UPDATE slot SET recipeId = ? WHERE id = ?", [recipeId, slotID]);
  }
}
