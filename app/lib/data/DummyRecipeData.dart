import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/model/RecipeImage.dart';
import 'package:sqflite/sqflite.dart';

Future<int> insertDummyRecipes(List<Recipe> dummyRecipes, Database db) async {
  var res;

  for (var dummyRecipe in dummyRecipes) {
    var recipe = dummyRecipe;

    // Recipe
    res = await db.rawInsert(
        "INSERT INTO recipe (name, description, backgroundColor)"
        "VALUES (?, ?, ?)",
        [recipe.name, recipe.description, Recipe.randomBackgroundColor()]);

    var lastInsertedIdQuery = await db.rawQuery("SELECT last_insert_rowid()");
    var lastInsertedRecipeId = lastInsertedIdQuery.first.values.first;

    // Image
    res = await db.rawInsert(
        "INSERT INTO image (path, recipeId)"
        "VALUES (?, ?)",
        [recipe.image.path, lastInsertedRecipeId]);

    lastInsertedIdQuery = await db.rawQuery("SELECT last_insert_rowid()");
    var lastInsertedImageId = lastInsertedIdQuery.first.values.first;

    res = await db.rawUpdate("UPDATE recipe SET imageId = ? WHERE id = ?",
        [lastInsertedImageId, lastInsertedRecipeId]);

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

        var lastInsertedIdQuery =
            await db.rawQuery("SELECT last_insert_rowid()");
        var lastInsertedCategoryId = lastInsertedIdQuery.first.values.first;

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

        var lastInsertedIdQuery =
            await db.rawQuery("SELECT last_insert_rowid()");
        var lastInsertedIngredientId = lastInsertedIdQuery.first.values.first;

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
  }

  return res;
}

List<Recipe> dummyRecipes = [
  Recipe(
      id: 1,
      name: "Pfannkuchen",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: ""),
      categories: [
        Category(id: 1, name: "Bayerisch"),
        Category(id: 2, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Eier"),
        Ingredient(id: 2, name: "Wasser"),
        Ingredient(id: 3, name: "Mehl")
      ]),
  Recipe(
      id: 2,
      name: "Schinkennudeln",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: ""),
      categories: [
        Category(id: 3, name: "Schnell")
      ],
      ingredients: [
        Ingredient(id: 4, name: "Schinken"),
        Ingredient(id: 5, name: "Nudeln"),
        Ingredient(id: 6, name: "Zwiebeln")
      ]),
  Recipe(
      id: 3,
      name: "Pizza",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: ""),
      categories: [
        Category(id: 3, name: "Schnell"),
        Category(id: 4, name: "Kulinarisch")
      ],
      ingredients: [
        Ingredient(id: 3, name: "Mehl"),
        Ingredient(id: 2, name: "Wasser"),
        Ingredient(id: 4, name: "Schinken")
      ])
];
