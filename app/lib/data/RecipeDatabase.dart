import 'dart:math';

import 'package:foodplan/model/Category.dart';
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
List<String> baseCategories = [
  "Fleisch",
  "Suppe",
  "Vegetarisch",
  "Deftig",
  "Low Carb",
  "Sonntagsessen",
  "Traditionell"
];
List<String> baseIngredients = [
  "Reis",
  "Zwiebeln",
  "Olivenöl",
  "Knoblauch",
  "Reis",
  "Hackfleisch",
  "Putenfleisch",
  "Mehl",
  "Milch"
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
      await db.execute("PRAGMA foreign_keys = ON");

      // Create tables
      // recipe table
      await db.execute("CREATE TABLE recipe ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT,"
          "backgroundColor INTEGER"
          ")");
      // slot table
      await db.execute("CREATE TABLE slot ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT,"
          "recipeId INTEGER,"
          "FOREIGN KEY (recipeId) REFERENCES recipe(id)"
          ")");
      // category table
      await db.execute("CREATE TABLE category ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT"
          ")");
      await db.execute("CREATE TABLE recipe_category ("
          "recipeId INTEGER,"
          "categoryId INTEGER,"
          "FOREIGN KEY (recipeId) REFERENCES recipe(id),"
          "FOREIGN KEY (categoryId) REFERENCES category(id)"
          ")");
      // ingredient table
      await db.execute("CREATE TABLE ingredient ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name TEXT"
          ")");
      await db.execute("CREATE TABLE recipe_ingredient ("
          "recipeId INTEGER,"
          "ingredientId INTEGER,"
          "FOREIGN KEY (recipeId) REFERENCES recipe(id),"
          "FOREIGN KEY (ingredientId) REFERENCES ingredient(id)"
          ")");
      // image table
      await db.execute("CREATE TABLE image ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "path TEXT"
          ")");
      await db.execute("CREATE TABLE recipe_image ("
          "recipeId INTEGER,"
          "imageId INTEGER,"
          "FOREIGN KEY (recipeId) REFERENCES recipe(id),"
          "FOREIGN KEY (imageId) REFERENCES image(id)"
          ")");

      // Insert dummies
      // recipes
      for (String recipe in baseRecipes) {
        int rndColorInt = (Random().nextDouble() * 0xFFFFFF).toInt();
        await db.rawInsert(
            "INSERT INTO recipe (name, backgroundColor)"
            " VALUES (?, ?)",
            [recipe, rndColorInt]);
      }
      // slots
      for (String slot in baseSlots) {
        await db.rawInsert(
            "INSERT INTO slot (name, recipeId)"
            " VALUES (?, (SELECT id FROM recipe ORDER BY RANDOM() LIMIT 1))",
            [slot]);
      }
      // categories
      for (String category in baseCategories) {
        await db.rawInsert(
            "INSERT INTO category (name)"
            " VALUES (?)",
            [category]);
      }
      // categories
      for (String ingredient in baseIngredients) {
        await db.rawInsert(
            "INSERT INTO ingredient (name)"
            " VALUES (?)",
            [ingredient]);
      }
    });
  }

  Future<int> newRecipe(Recipe newRecipe, List<int> categoryIds) async {
    int rndColorInt = (Random().nextDouble() * 0xFFFFFF).toInt();
    final db = await database;
    var res = await db.rawInsert(
        "INSERT INTO recipe (name, backgroundColor)"
        "VALUES (?, ?)",
        [newRecipe.name, rndColorInt]);
    var lastInsertedRecipeIdQuery =
        await db.rawQuery("SELECT last_insert_rowid()");
    var lastInsertedRecipeId = lastInsertedRecipeIdQuery.first.values.first;
    categoryIds.forEach((categoryId) async {
      res = await db.rawInsert(
          "INSERT INTO recipe_category (recipeId, categoryId)"
          "VALUES (?, ?)",
          [lastInsertedRecipeId, categoryId]);
    });
    return res;
  }

  Future<List<dynamic>> getRecipesForSearch(
      String searchPhrase, List<int> categoryIds) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT id, name, backgroundColor FROM recipe ORDER BY name ASC");
    if (searchPhrase.isNotEmpty) {
      res = await db.rawQuery(
          "SELECT id, name, backgroundColor FROM recipe WHERE name LIKE ? ORDER BY name ASC",
          ["$searchPhrase%"]);
    }
    if (categoryIds.isNotEmpty) {
      // String query = "SELECT DISTINCT id, name, backgroundColor "
      //     "FROM recipe INNER JOIN recipe_category ON recipe.id = recipe_category.recipeId "
      //     "WHERE " + _generateQueryConditionIn(categoryIds) + " ORDER BY name ASC";
      String query = _generateQueryConditionIntersection(categoryIds);
      res = await db.rawQuery(query);
    }
    if(searchPhrase.isNotEmpty && categoryIds.isNotEmpty) {
      String query = "SELECT DISTINCT recipeId, name, backgroundColor FROM (" + _generateQueryConditionIntersection(categoryIds) + ") AS intersecTable WHERE name LIKE ? ORDER BY name ASC";
      print(query);
      res = await db.rawQuery(query, ["$searchPhrase%"]);
    }
    List<Recipe> list =
        res.isNotEmpty ? res.map((c) => Recipe.fromMap(c)).toList() : [];
    list.forEach((element) {print(element.name);});
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

  // Category
  Future<List<dynamic>> getAllCategories() async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT id, name FROM category ORDER BY name ASC");
    List<Category> list =
        res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
    return list;
  }
}

String _generateQueryConditionIntersection(List<int> categoryIds) {
  String catQuery = "";
  if (categoryIds.isNotEmpty) {
    int n = 1;
    categoryIds.forEach((element) {
      catQuery += "SELECT DISTINCT recipeId, recipe.name, recipe.backgroundColor FROM recipe_category, recipe WHERE categoryId = ";
      catQuery += element.toString();
      catQuery += " AND recipe.id = recipe_category.recipeId";
      if (n < categoryIds.length) {
        catQuery += " INTERSECT ";
      }
      n++;
    });
  } else {
    catQuery = "";
  }
  return catQuery;
}

String _generateQueryCondition(List<int> categoryIds) {
  String catQuery;
  if (categoryIds.isNotEmpty) {
    catQuery = " recipe_category.categoryId = ";
    int n = 1;
    categoryIds.forEach((element) {
      catQuery += element.toString();
      if (n < categoryIds.length) {
        catQuery += " AND recipe_category.categoryId = ";
      }
      n++;
    });
  } else {
    catQuery = "";
  }
  return catQuery;
}

String _generateQueryConditionIn(List<int> categoryIds) {
  String catQuery;
  if (categoryIds.isNotEmpty) {
    catQuery = "recipe_category.categoryId IN (";
    int n = 1;
    categoryIds.forEach((element) {
      catQuery += element.toString();
      if (n < categoryIds.length) {
        catQuery += ", ";
      }
      n++;
    });
    catQuery += ")";
  } else {
    catQuery = "";
  }
  return catQuery;
}
