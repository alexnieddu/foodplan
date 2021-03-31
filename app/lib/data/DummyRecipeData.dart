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
      name: "Pilz-Rahmsauce",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 2, name: "Sauce"),
        Category(id: 2, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Pilze"),
        Ingredient(id: 2, name: "Knoblauchzehe"),
        Ingredient(id: 3, name: "Tomatenmark"),
        Ingredient(id: 3, name: "Sojasauce"),
        Ingredient(id: 3, name: "Sahne")
      ]),
  Recipe(
      id: 1,
      name: "Gemüsetarte",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 2, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Joghurt"),
        Ingredient(id: 2, name: "Butter"),
        Ingredient(id: 3, name: "Zucchini"),
        Ingredient(id: 3, name: "Paprika"),
        Ingredient(id: 3, name: "Pilze"),
        Ingredient(id: 3, name: "Frühlingszwiebeln"),
        Ingredient(id: 3, name: "Karotte"),
        Ingredient(id: 3, name: "Tomate"),
        Ingredient(id: 3, name: "Eier"),
        Ingredient(id: 3, name: "Käse"),
        Ingredient(id: 3, name: "Creme Fraiche")
      ]),
  Recipe(
      id: 1,
      name: "Bayerische Schinkenudeln",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 2, name: "Bayerisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Nudeln"),
        Ingredient(id: 2, name: "Schinken"),
        Ingredient(id: 3, name: "Eier")
      ]),
  Recipe(
      id: 1,
      name: "Vegetarischer Nudelauflauf",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 2, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Nudeln"),
        Ingredient(id: 2, name: "Sahne"),
        Ingredient(id: 3, name: "Tomatenmark"),
        Ingredient(id: 3, name: "Knoblauch"),
        Ingredient(id: 3, name: "Käse"),
        Ingredient(id: 3, name: "Tomaten")
      ]),
  Recipe(
      id: 1,
      name: "Gefüllte Paprika",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Reis"),
        Ingredient(id: 2, name: "Knoblauchzehe"),
        Ingredient(id: 3, name: "Hackfleisch"),
        Ingredient(id: 3, name: "Eier"),
        Ingredient(id: 3, name: "Paprika"),
        Ingredient(id: 3, name: "Tomatenmark")
      ]),
  Recipe(
      id: 1,
      name: "Gulasch",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 1, name: "Deftig")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Knoblauchzehe"),
        Ingredient(id: 2, name: "Rindfleisch"),
        Ingredient(id: 3, name: "Schweinefleisch"),
        Ingredient(id: 3, name: "Creme Fraiche"),
        Ingredient(id: 3, name: "Paprika"),
        Ingredient(id: 3, name: "Tomatenmark")
      ]),
  Recipe(
      id: 1,
      name: "Asia Pfanne süß sauer",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 1, name: "Asiatisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Putenfleisch"),
        Ingredient(id: 2, name: "Ananas"),
        Ingredient(id: 3, name: "Sojasauce"),
        Ingredient(id: 3, name: "Essig"),
        Ingredient(id: 3, name: "Paprika"),
        Ingredient(id: 3, name: "Tomatenmark")
      ]),
  Recipe(
      id: 1,
      name: "Chilli Sahne Schnitzel",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 1, name: "Feurig")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Schweinefleisch"),
        Ingredient(id: 2, name: "Putenfleisch"),
        Ingredient(id: 3, name: "Knoblauchzehe"),
        Ingredient(id: 3, name: "Sahne"),
        Ingredient(id: 3, name: "Chilli")
      ]),
  Recipe(
      id: 1,
      name: "Überbackenes Putenfilet mit Frischkäse",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Putenfleisch"),
        Ingredient(id: 2, name: "Frischkäse"),
        Ingredient(id: 3, name: "Käse"),
        Ingredient(id: 3, name: "Eier")
      ]),
  Recipe(
      id: 1,
      name: "Überbackenes Gnocchi mit Paprika Tomaten Sauce",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 1, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Gnocchi"),
        Ingredient(id: 2, name: "Paprika"),
        Ingredient(id: 3, name: "Knoblauchzehe"),
        Ingredient(id: 3, name: "passierte Tomaten"),
        Ingredient(id: 3, name: "Frischkäse"),
        Ingredient(id: 3, name: "Mozzarella"),
        Ingredient(id: 3, name: "Parmesan")
      ]),
  Recipe(
      id: 1,
      name: "Bauerntopf",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 1, name: "Deftig")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Hackfleisch"),
        Ingredient(id: 2, name: "Dosentomaten"),
        Ingredient(id: 3, name: "Tomatenmark"),
        Ingredient(id: 3, name: "Paprika"),
        Ingredient(id: 3, name: "Kartoffeln"),
        Ingredient(id: 3, name: "Creme Fraiche"),
        Ingredient(id: 3, name: "Karotten")
      ]),
  Recipe(
      id: 1,
      name: "Winterpfanne mit gebratenen Wallnüssen",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 1, name: "Vegan")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Wallnüsse"),
        Ingredient(id: 2, name: "Kartoffeln"),
        Ingredient(id: 3, name: "Pilze"),
        Ingredient(id: 3, name: "Wirsing")
      ]),
  Recipe(
      id: 1,
      name: "Rosmarin Balsamico Schweinefilet",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Hauptspeise"),
        Category(id: 1, name: "Festlich")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Schweinefleisch"),
        Ingredient(id: 2, name: "Rosmarin"),
        Ingredient(id: 3, name: "Weißwein"),
        Ingredient(id: 3, name: "Balsamicoessig")
      ]),
  Recipe(
      id: 1,
      name: "Brezenknödel",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Beilage"),
        Category(id: 1, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Brezen"),
        Ingredient(id: 2, name: "Milch"),
        Ingredient(id: 3, name: "Eier")
      ]),
  Recipe(
      id: 1,
      name: "Süßkartoffel Kokos Suppe",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Suppe"),
        Category(id: 1, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Ingwer"),
        Ingredient(id: 2, name: "Knoblauchzehe"),
        Ingredient(id: 2, name: "Kokosmilch"),
        Ingredient(id: 2, name: "Zitrone"),
        Ingredient(id: 3, name: "Süßkartoffeln")
      ]),
  Recipe(
      id: 1,
      name: "Paprikasuppe",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Suppe"),
        Category(id: 1, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Paprika"),
        Ingredient(id: 2, name: "Knoblauchzehe"),
        Ingredient(id: 2, name: "Tomatenmark"),
        Ingredient(id: 2, name: "Essig"),
        Ingredient(id: 3, name: "Creme Fraiche")
      ]),
  Recipe(
      id: 1,
      name: "Kalte Radiserlsuppe mit Ziegenfrischkäse",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Suppe"),
        Category(id: 1, name: "Bayerisch"),
        Category(id: 1, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Radieschen"),
        Ingredient(id: 2, name: "Avocado"),
        Ingredient(id: 2, name: "Spinat"),
        Ingredient(id: 2, name: "Zitrone"),
        Ingredient(id: 3, name: "Ziegenfrischkäse")
      ]),
  Recipe(
      id: 1,
      name: "Sour Creme",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Soße"),
        Category(id: 1, name: "Dip"),
        Category(id: 1, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 2, name: "Knoblauchzehe"),
        Ingredient(id: 2, name: "Schnittlauch"),
        Ingredient(id: 2, name: "Mayonnaise"),
        Ingredient(id: 2, name: "Creme Fraiche"),
        Ingredient(id: 2, name: "Saure Sahne"),
        Ingredient(id: 3, name: "Magerquark")
      ]),
  Recipe(
      id: 1,
      name: "Birnen Obazda",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Aufstrich"),
        Category(id: 1, name: "Bayerisch"),
        Category(id: 1, name: "Vegetarisch")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Wallnuss"),
        Ingredient(id: 2, name: "Birne"),
        Ingredient(id: 2, name: "Blauschimmelkäse"),
        Ingredient(id: 2, name: "Frischkäse")
      ]),
  Recipe(
      id: 1,
      name: "Schoko Tiramisu",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Dessert")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Sahne"),
        Ingredient(id: 2, name: "Vanillinzucker"),
        Ingredient(id: 2, name: "Paradiscreme"),
        Ingredient(id: 2, name: "Milch"),
        Ingredient(id: 2, name: "Kakao"),
        Ingredient(id: 3, name: "Kekse")
      ]),
  Recipe(
      id: 1,
      name: "Tiramisu alla Silvio",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Dessert")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Eier"),
        Ingredient(id: 2, name: "Mascarpone"),
        Ingredient(id: 2, name: "Amaretto"),
        Ingredient(id: 2, name: "Kekse"),
        Ingredient(id: 2, name: "Espresso")
      ]),
  Recipe(
      id: 1,
      name: "Hannahs Best Muffins Ever",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Dessert")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Zartbitterschokolade"),
        Ingredient(id: 2, name: "Butter"),
        Ingredient(id: 2, name: "Eier"),
        Ingredient(id: 2, name: "Rohrzucker")
      ]),
  Recipe(
      id: 1,
      name: "Überbackene Brezen",
      description: "Lorem ipsum dolor sit ...",
      image: RecipeImage(id: 1, path: null),
      categories: [
        Category(id: 1, name: "Brotzeit")
      ],
      ingredients: [
        Ingredient(id: 1, name: "Brezen"),
        Ingredient(id: 2, name: "Schinken"),
        Ingredient(id: 2, name: "Frühlingszwiebeln"),
        Ingredient(id: 2, name: "Käse"),
        Ingredient(id: 2, name: "Frischkäse"),
        Ingredient(id: 2, name: "Eier")
      ]),

  // Recipe(
  //     id: 1,
  //     name: "Pfannkuchen",
  //     description: "Lorem ipsum dolor sit ...",
  //     image: RecipeImage(id: 1, path: null),
  //     categories: [
  //       Category(id: 1, name: "Bayerisch"),
  //       Category(id: 2, name: "Vegetarisch")
  //     ],
  //     ingredients: [
  //       Ingredient(id: 1, name: "Eier"),
  //       Ingredient(id: 2, name: "Wasser"),
  //       Ingredient(id: 3, name: "Mehl")
  //     ]),
  // Recipe(
  //     id: 2,
  //     name: "Schinkennudeln",
  //     description: "Lorem ipsum dolor sit ...",
  //     image: RecipeImage(id: 1, path: null),
  //     categories: [
  //       Category(id: 3, name: "Schnell")
  //     ],
  //     ingredients: [
  //       Ingredient(id: 4, name: "Schinken"),
  //       Ingredient(id: 5, name: "Nudeln"),
  //       Ingredient(id: 6, name: "Zwiebeln")
  //     ]),
  // Recipe(
  //     id: 3,
  //     name: "Pizza",
  //     description: "Lorem ipsum dolor sit ...",
  //     image: RecipeImage(id: 1, path: null),
  //     categories: [
  //       Category(id: 3, name: "Schnell"),
  //       Category(id: 4, name: "Kulinarisch")
  //     ],
  //     ingredients: [
  //       Ingredient(id: 3, name: "Mehl"),
  //       Ingredient(id: 2, name: "Wasser"),
  //       Ingredient(id: 4, name: "Schinken")
  //     ])
];
