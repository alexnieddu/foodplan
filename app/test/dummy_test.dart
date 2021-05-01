import 'dart:convert';

import "package:flutter_test/flutter_test.dart";
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/model/RecipeImage.dart';
import 'package:foodplan/data/DummyRecipeData.dart';
import 'package:http/http.dart' as http;

final String serverRecipeUrl = "https://kinu-app.com/foodplan/dummy.json";

final jsonRecipe = {
  "id": 1,
  "name": "Pizza",
  "description": "Va bene ...",
  "backgroundColor": 12345678,
  "image": {"id": 1, "path": "dsa"},
  "categories": [
    {"id": 1, "name": "Italienisch"}
  ],
  "ingredients": [
    {"id": 1, "name": "Mehl"},
    {"id": 2, "name": "Salami"},
  ]
};

final dummies = [
  {
    "id": 1,
    "name": "Pilz-Rahmsauce",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 2, "name": "Sauce"},
      {"id": 2, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Pilze"},
      {"id": 2, "name": "Knoblauchzehe"},
      {"id": 3, "name": "Tomatenmark"},
      {"id": 3, "name": "Sojasauce"},
      {"id": 3, "name": "Sahne"}
    ]
  },
  {
    "id": 1,
    "name": "Gemüsetarte",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 2, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Joghurt"},
      {"id": 2, "name": "Butter"},
      {"id": 3, "name": "Zucchini"},
      {"id": 3, "name": "Paprika"},
      {"id": 3, "name": "Pilze"},
      {"id": 3, "name": "Frühlingszwiebeln"},
      {"id": 3, "name": "Karotte"},
      {"id": 3, "name": "Tomate"},
      {"id": 3, "name": "Eier"},
      {"id": 3, "name": "Käse"},
      {"id": 3, "name": "Creme Fraiche"}
    ]
  },
  {
    "id": 1,
    "name": "Bayerische Schinkenudeln",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 2, "name": "Bayerisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Nudeln"},
      {"id": 2, "name": "Schinken"},
      {"id": 3, "name": "Eier"}
    ]
  },
  {
    "id": 1,
    "name": "Vegetarischer Nudelauflauf",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 2, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Nudeln"},
      {"id": 2, "name": "Sahne"},
      {"id": 3, "name": "Tomatenmark"},
      {"id": 3, "name": "Knoblauch"},
      {"id": 3, "name": "Käse"},
      {"id": 3, "name": "Tomaten"}
    ]
  },
  {
    "id": 1,
    "name": "Gefüllte Paprika",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"}
    ],
    "ingredients": [
      {"id": 1, "name": "Reis"},
      {"id": 2, "name": "Knoblauchzehe"},
      {"id": 3, "name": "Hackfleisch"},
      {"id": 3, "name": "Eier"},
      {"id": 3, "name": "Paprika"},
      {"id": 3, "name": "Tomatenmark"}
    ]
  },
  {
    "id": 1,
    "name": "Gulasch",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 1, "name": "Deftig"}
    ],
    "ingredients": [
      {"id": 1, "name": "Knoblauchzehe"},
      {"id": 2, "name": "Rindfleisch"},
      {"id": 3, "name": "Schweinefleisch"},
      {"id": 3, "name": "Creme Fraiche"},
      {"id": 3, "name": "Paprika"},
      {"id": 3, "name": "Tomatenmark"}
    ]
  },
  {
    "id": 1,
    "name": "Asia Pfanne süß sauer",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 1, "name": "Asiatisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Putenfleisch"},
      {"id": 2, "name": "Ananas"},
      {"id": 3, "name": "Sojasauce"},
      {"id": 3, "name": "Essig"},
      {"id": 3, "name": "Paprika"},
      {"id": 3, "name": "Tomatenmark"}
    ]
  },
  {
    "id": 1,
    "name": "Chilli Sahne Schnitzel",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 1, "name": "Feurig"}
    ],
    "ingredients": [
      {"id": 1, "name": "Schweinefleisch"},
      {"id": 2, "name": "Putenfleisch"},
      {"id": 3, "name": "Knoblauchzehe"},
      {"id": 3, "name": "Sahne"},
      {"id": 3, "name": "Chilli"}
    ]
  },
  {
    "id": 1,
    "name": "Überbackenes Putenfilet mit Frischkäse",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"}
    ],
    "ingredients": [
      {"id": 1, "name": "Putenfleisch"},
      {"id": 2, "name": "Frischkäse"},
      {"id": 3, "name": "Käse"},
      {"id": 3, "name": "Eier"}
    ]
  },
  {
    "id": 1,
    "name": "Überbackenes Gnocchi mit Paprika Tomaten Sauce",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 1, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Gnocchi"},
      {"id": 2, "name": "Paprika"},
      {"id": 3, "name": "Knoblauchzehe"},
      {"id": 3, "name": "passierte Tomaten"},
      {"id": 3, "name": "Frischkäse"},
      {"id": 3, "name": "Mozzarella"},
      {"id": 3, "name": "Parmesan"}
    ]
  },
  {
    "id": 1,
    "name": "Bauerntopf",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 1, "name": "Deftig"}
    ],
    "ingredients": [
      {"id": 1, "name": "Hackfleisch"},
      {"id": 2, "name": "Dosentomaten"},
      {"id": 3, "name": "Tomatenmark"},
      {"id": 3, "name": "Paprika"},
      {"id": 3, "name": "Kartoffeln"},
      {"id": 3, "name": "Creme Fraiche"},
      {"id": 3, "name": "Karotten"}
    ]
  },
  {
    "id": 1,
    "name": "Winterpfanne mit gebratenen Wallnüssen",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 1, "name": "Vegan"}
    ],
    "ingredients": [
      {"id": 1, "name": "Wallnüsse"},
      {"id": 2, "name": "Kartoffeln"},
      {"id": 3, "name": "Pilze"},
      {"id": 3, "name": "Wirsing"}
    ]
  },
  {
    "id": 1,
    "name": "Rosmarin Balsamico Schweinefilet",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Hauptspeise"},
      {"id": 1, "name": "Festlich"}
    ],
    "ingredients": [
      {"id": 1, "name": "Schweinefleisch"},
      {"id": 2, "name": "Rosmarin"},
      {"id": 3, "name": "Weißwein"},
      {"id": 3, "name": "Balsamicoessig"}
    ]
  },
  {
    "id": 1,
    "name": "Brezenknödel",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Beilage"},
      {"id": 1, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Brezen"},
      {"id": 2, "name": "Milch"},
      {"id": 3, "name": "Eier"}
    ]
  },
  {
    "id": 1,
    "name": "Süßkartoffel Kokos Suppe",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Suppe"},
      {"id": 1, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Ingwer"},
      {"id": 2, "name": "Knoblauchzehe"},
      {"id": 2, "name": "Kokosmilch"},
      {"id": 2, "name": "Zitrone"},
      {"id": 3, "name": "Süßkartoffeln"}
    ]
  },
  {
    "id": 1,
    "name": "Paprikasuppe",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Suppe"},
      {"id": 1, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Paprika"},
      {"id": 2, "name": "Knoblauchzehe"},
      {"id": 2, "name": "Tomatenmark"},
      {"id": 2, "name": "Essig"},
      {"id": 3, "name": "Creme Fraiche"}
    ]
  },
  {
    "id": 1,
    "name": "Kalte Radiserlsuppe mit Ziegenfrischkäse",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Suppe"},
      {"id": 1, "name": "Bayerisch"},
      {"id": 1, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Radieschen"},
      {"id": 2, "name": "Avocado"},
      {"id": 2, "name": "Spinat"},
      {"id": 2, "name": "Zitrone"},
      {"id": 3, "name": "Ziegenfrischkäse"}
    ]
  },
  {
    "id": 1,
    "name": "Sour Creme",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Soße"},
      {"id": 1, "name": "Dip"},
      {"id": 1, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 2, "name": "Knoblauchzehe"},
      {"id": 2, "name": "Schnittlauch"},
      {"id": 2, "name": "Mayonnaise"},
      {"id": 2, "name": "Creme Fraiche"},
      {"id": 2, "name": "Saure Sahne"},
      {"id": 3, "name": "Magerquark"}
    ]
  },
  {
    "id": 1,
    "name": "Birnen Obazda",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Aufstrich"},
      {"id": 1, "name": "Bayerisch"},
      {"id": 1, "name": "Vegetarisch"}
    ],
    "ingredients": [
      {"id": 1, "name": "Wallnuss"},
      {"id": 2, "name": "Birne"},
      {"id": 2, "name": "Blauschimmelkäse"},
      {"id": 2, "name": "Frischkäse"}
    ]
  },
  {
    "id": 1,
    "name": "Schoko Tiramisu",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Dessert"}
    ],
    "ingredients": [
      {"id": 1, "name": "Sahne"},
      {"id": 2, "name": "Vanillinzucker"},
      {"id": 2, "name": "Paradiscreme"},
      {"id": 2, "name": "Milch"},
      {"id": 2, "name": "Kakao"},
      {"id": 3, "name": "Kekse"}
    ]
  },
  {
    "id": 1,
    "name": "Tiramisu alla Silvio",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Dessert"}
    ],
    "ingredients": [
      {"id": 1, "name": "Eier"},
      {"id": 2, "name": "Mascarpone"},
      {"id": 2, "name": "Amaretto"},
      {"id": 2, "name": "Kekse"},
      {"id": 2, "name": "Espresso"}
    ]
  },
  {
    "id": 1,
    "name": "Hannahs Best Muffins Ever",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Dessert"}
    ],
    "ingredients": [
      {"id": 1, "name": "Zartbitterschokolade"},
      {"id": 2, "name": "Butter"},
      {"id": 2, "name": "Eier"},
      {"id": 2, "name": "Rohrzucker"}
    ]
  },
  {
    "id": 1,
    "name": "Überbackene Brezen",
    "description": "Lorem ipsum dolor sit ...",
    "backgroundColor": null,
    "image": {"id": 1, "path": null},
    "categories": [
      {"id": 1, "name": "Brotzeit"}
    ],
    "ingredients": [
      {"id": 1, "name": "Brezen"},
      {"id": 2, "name": "Schinken"},
      {"id": 2, "name": "Frühlingszwiebeln"},
      {"id": 2, "name": "Käse"},
      {"id": 2, "name": "Frischkäse"},
      {"id": 2, "name": "Eier"}
    ]
  }
];

void main() {
  test("Recipe to JSON", () {
    RecipeImage img = RecipeImage(id: 1, path: "dsa");
    Category italy = Category(id: 1, name: "Italienisch");
    Ingredient mehl = Ingredient(id: 1, name: "Mehl");
    Ingredient salami = Ingredient(id: 2, name: "Salami");
    Recipe pizza = Recipe(
        id: 1,
        name: "Pizza",
        description: "Va bene ...",
        backgroundColor: 12345678,
        image: img,
        categories: [italy],
        ingredients: [mehl, salami]);

    expect(pizza.toMap(), jsonRecipe);
  });
  test("JSON to Recipe", () {
    Recipe pizza = Recipe.fromMap(jsonRecipe);

    expect(pizza.toMap(), jsonRecipe);
  });
  test("Print dummy recipes", () {
    final json = List<dynamic>.from(dummyRecipes.map((e) => e.toMap()));

    json.forEach((element) {
      print(element);
      print(",");
    });

    expect(1, 1);
  });
  test("Https request for recipes", () async {
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var response = await http.get(serverRecipeUrl, headers: headers);
    if (response.statusCode == 200) {
      var recipeMap = jsonDecode(utf8.decode(response.bodyBytes));

      for (var recipe in recipeMap) {
        Recipe rec = Recipe.fromMapApi(recipe);
        print(rec.name);
      }
    }

    expect(1, 1);
  });
  test("Retrieve all recipes", () async {
    List<Recipe> allRecipes = await RecipeDatabase.db.getLocalRecipes();

    for (var recipe in allRecipes) {
      print(recipe.toMap().toString());
    }

    expect(1, 1);
  });
}