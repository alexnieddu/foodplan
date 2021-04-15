import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/RecipeImage.dart';
import 'package:foodplan/model/Slot.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/model/Slot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'DummyRecipeData.dart';

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
          "description TEXT,"
          "imageId INTEGER,"
          "backgroundColor INTEGER,"
          "FOREIGN KEY (imageId) REFERENCES image(id)"
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
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "path TEXT, "
          "isDescriptionImage INTEGER, "
          "recipeId INTEGER, "
          "FOREIGN KEY (recipeId) REFERENCES recipe(id)"
          ")");

      // Insert dummies

      // recipes
      // for (String recipe in baseRecipes) {
      //   int rndColorInt = (Random().nextDouble() * 0xFFFFFF).toInt();
      //   await db.rawInsert(
      //       "INSERT INTO recipe (name, backgroundColor)"
      //       " VALUES (?, ?)",
      //       [recipe, rndColorInt]);
      // }
      // slots
      // for (String slot in baseSlots) {
      //   await db.rawInsert(
      //       "INSERT INTO slot (name, recipeId)"
      //       " VALUES (?, (SELECT id FROM recipe ORDER BY RANDOM() LIMIT 1))",
      //       [slot]);
      // }
      // categories
      for (String category in baseCategories) {
        await db.rawInsert(
            "INSERT INTO category (name)"
            " VALUES (?)",
            [category]);
      }
      // ingredients
      for (String ingredient in baseIngredients) {
        await db.rawInsert(
            "INSERT INTO ingredient (name)"
            " VALUES (?)",
            [ingredient]);
      }

      // await insertDummyRecipes(dummyRecipes, db);
    });
  }

  Future<int> insert(Recipe recipe) async {
    var res;
    final db = await database;

    // Recipe
    res = await db.rawInsert(
        "INSERT INTO recipe (name, description, backgroundColor)"
        "VALUES (?, ?, ?)",
        [recipe.name, recipe.description, recipe.backgroundColor]);

    var lastInsertedRecipeId = await lastInsertedId();

    // Image food
    res = await db.rawInsert(
        "INSERT INTO image (path, recipeId, isDescriptionImage)"
        "VALUES (?, ?, 0)",
        [recipe.image.path, lastInsertedRecipeId]);

    var lastInsertedImageId = await lastInsertedId();

    res = await db.rawUpdate("UPDATE recipe SET imageId = ? WHERE id = ?",
        [lastInsertedImageId, lastInsertedRecipeId]);

    // Image recipe
    res = await db.rawInsert(
        "INSERT INTO image (path, recipeId, isDescriptionImage)"
        "VALUES (?, ?, 1)",
        [recipe.descriptionImage.path, lastInsertedRecipeId]);

    // Categories
    for (var category in recipe.categories) {
      print(recipe.name + ": " + category.name);
      // look for existing entry
      var categoryId = await db
          .rawQuery("SELECT id FROM category WHERE name = ?", [category.name]);

      if (categoryId.isEmpty) {
        // create new category entry
        res = await db.rawInsert(
            "INSERT INTO category (name)"
            "VALUES (?)",
            [category.name]);

        var lastInsertedCategoryId = await lastInsertedId();

        res = await db.rawInsert(
            "INSERT INTO recipe_category (recipeId, categoryId)"
            "VALUES (?, ?)",
            [lastInsertedRecipeId, lastInsertedCategoryId]);
      } else {
        res = await db.rawInsert(
            "INSERT INTO recipe_category (recipeId, categoryId)"
            "VALUES (?, ?)",
            [lastInsertedRecipeId, categoryId.first.values.first]);
      }
    }

    // Ingredients
    for (var ingredient in recipe.ingredients) {
      print(recipe.name + ": " + ingredient.name);
      // look for existing entry
      var ingredientId = await db.rawQuery(
          "SELECT id FROM ingredient WHERE name = ?", [ingredient.name]);

      if (ingredientId.isEmpty) {
        // create new ingredient entry
        res = await db.rawInsert(
            "INSERT INTO ingredient (name)"
            "VALUES (?)",
            [ingredient.name]);

        var lastInsertedIngredientId = await lastInsertedId();

        res = await db.rawInsert(
            "INSERT INTO recipe_ingredient (recipeId, ingredientId)"
            "VALUES (?, ?)",
            [lastInsertedRecipeId, lastInsertedIngredientId]);
      } else {
        res = await db.rawInsert(
            "INSERT INTO recipe_ingredient (recipeId, ingredientId)"
            "VALUES (?, ?)",
            [lastInsertedRecipeId, ingredientId.first.values.first]);
      }
    }

    return res;
  }

  Future<Recipe> getRecipe(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT id, name, description, backgroundColor, imageId FROM recipe WHERE id = ?",
        [id]);

    var recipe = Recipe.fromMap(res.first);

    // Fetch FOOD IMAGE from db and add path to recipe
    if (recipe.image.id != null) {
      res = await db.rawQuery(
          "SELECT path FROM image WHERE recipeId = ? AND isDescriptionImage = 0",
          [id]);
      recipe.image.path = res.first.values.first;
      recipe.image.isDescriptionImage = false;
    }

    // Fetch RECIPE IMAGE from db and add path to recipe
    if (recipe.image.id != null) {
      res = await db.rawQuery(
          "SELECT path FROM image WHERE recipeId = ? AND isDescriptionImage = 1",
          [id]);
      recipe.descriptionImage.path = res.first.values.first;
      recipe.descriptionImage.isDescriptionImage = true;
    }

    recipe.descriptionImage.isRemote = false;

    // Fetch INGREDIENTS from db and add them to recipe
    res = await db.rawQuery(
        "SELECT id, name FROM ingredient "
        "INNER JOIN recipe_ingredient ON recipe_ingredient.ingredientId = ingredient.id "
        "WHERE recipe_ingredient.recipeId = ? "
        "ORDER BY name ASC",
        [id]);

    res.forEach((ingredient) {
      var ingredientDb = Ingredient.fromMap(ingredient);
      recipe.ingredients.add(ingredientDb);
    });

    // Fetch CATEGORIES from db and add them to recipe
    res = await db.rawQuery(
        "SELECT id, name FROM category "
        "INNER JOIN recipe_category ON recipe_category.categoryId = category.id "
        "WHERE recipe_category.recipeId = ? "
        "ORDER BY name ASC",
        [id]);

    res.forEach((category) {
      var categoryDb = Category.fromMap(category);
      recipe.categories.add(categoryDb);
    });

    return recipe;
  }

  Future<List<Recipe>> getRecipesForSearch(
      String searchPhrase, List<String> categories) async {
    final List<Recipe> recipes = await getAllRecipes();
    var searchResultsText = recipes;
    List<Recipe> searchResults;

    // Works only for 1 search word
    bool nameOrIngredientFound(Recipe recipe) {
      var found = false;
      var ingredientsName = false;
      var recipeName =
          recipe.name.toUpperCase().contains(searchPhrase.toUpperCase());
      recipe.ingredients.forEach((ingredient) {
        ingredientsName |=
            ingredient.name.toUpperCase().contains(searchPhrase.toUpperCase());
      });
      found = recipeName || ingredientsName;
      return found;
    }

    bool categoryFound(Recipe recipe) {
      var found = true;
      final currentRecipeCategoryIds = recipe.getCategories();
      categories.forEach((name) {
        found &= currentRecipeCategoryIds.contains(name);
      });
      return found;
    }

    if (searchPhrase.isNotEmpty) {
      searchResultsText = recipes.where(nameOrIngredientFound).toList();
    }

    if (categories.isNotEmpty) {
      searchResults = searchResultsText.where(categoryFound).toList();
    } else {
      searchResults = searchResultsText;
    }
    return searchResults;
  }

  Future<List<Recipe>> getLocalRecipes() async {
    final Database db = await database;
    var res = await db.rawQuery("SELECT id FROM recipe ORDER BY name ASC");
    List<Recipe> recipes = [];

    List<Recipe> list =
        res.isNotEmpty ? res.map((c) => Recipe.fromMap(c)).toList() : [];

    for (var item in list) {
      var recipe = await RecipeDatabase.db.getRecipe(item.id);
      recipes.add(recipe);
    }

    return recipes;
  }

  Future<List<Recipe>> getRemoteRecipes() async {
    const int httpStatusOk = 200;
    List<Recipe> recipes = [];
    final String serverRecipeUrl = "https://kinu-app.com/foodplan/dummy.json";
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var response = await http.get(serverRecipeUrl, headers: headers);
    if (response.statusCode == httpStatusOk) {
      var recipeMap = jsonDecode(utf8.decode(response.bodyBytes));

      for (var recipe in recipeMap) {
        Recipe rec = Recipe.fromMapApi(recipe);
        recipes.add(rec);
      }
    } else {
      print("ERROR: Cannot retrieve remote recipes. Status: " +
          response.statusCode.toString());
    }

    return recipes;
  }

  Future<List<Recipe>> getAllRecipes() async {
    List<Recipe> localRecipes = await getLocalRecipes();
    List<Recipe> remoteRecipes = await getRemoteRecipes();
    List<Recipe> allRecipes = localRecipes + remoteRecipes;
    allRecipes.sort((a, b) => a.name.compareTo(b.name));
    return allRecipes;
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

  // Ingredients
  Future<List<dynamic>> getAllIngredients() async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT id, name FROM ingredient ORDER BY name ASC");
    List<Ingredient> list =
        res.isNotEmpty ? res.map((c) => Ingredient.fromMap(c)).toList() : [];
    return list;
  }

// START DEPRECATED ----------------------------------------------------
  Future<List<dynamic>> getIngredientsOfRecipe(int recipeId) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT id, name FROM ingredient INNER JOIN recipe_ingredient ON recipe_ingredient.ingredientId = ingredient.id WHERE recipe_ingredient.recipeId = ? ORDER BY name ASC LIMIT 3",
        [recipeId]);
    List<Ingredient> list =
        res.isNotEmpty ? res.map((c) => Ingredient.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<dynamic>> getImagePathOfRecipe(int recipeId) async {
    List<RecipeImage> list;
    final db = await database;
    // Get imageId of corresponding recipe
    var imageIdQuery = await db
        .rawQuery("SELECT imageID FROM recipe WHERE id = ?", [recipeId]);
    var imageId = imageIdQuery.first.values.first;
    // Get imagePath of corresponding recipe
    if (imageId != null) {
      var res = await db
          .rawQuery("SELECT id, path FROM image WHERE id = ?", [imageId]);
      list =
          res.isNotEmpty ? res.map((c) => RecipeImage.fromMap(c)).toList() : [];
    } else {
      list = [];
    }
    print(list);
    return list;
  }
  // END DEPRECATED ----------------------------------------------------

  Future<int> lastInsertedId() async {
    final db = await database;
    var lastInsertedIdQuery = await db.rawQuery("SELECT last_insert_rowid()");
    var lastInsertedId = lastInsertedIdQuery.first.values.first;
    return lastInsertedId;
  }
}
