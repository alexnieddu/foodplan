import 'dart:math';

import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/RecipeImage.dart';

class Recipe {
  int id;
  String name;
  String description;
  int backgroundColor;
  RecipeImage image;
  List<Category> categories;
  List<Ingredient> ingredients;

  Recipe(
      {this.id,
      this.name,
      this.description,
      this.backgroundColor,
      this.image,
      this.categories,
      this.ingredients});

  factory Recipe.fromMap(Map<String, dynamic> map) => Recipe(
        id: map["id"],
        name: map["name"],
        description: map["description"],
        backgroundColor: map["backgroundColor"],
        image: RecipeImage(id: map["imageId"], path: null),
        categories: [],
        ingredients: [],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "backgroundColor": backgroundColor,
        "image": {"id": image.id, "path": image.path},
      };

  List<int> getCategoryIds() {
    List<int> categoryIds = [];

    for (var category in this.categories) {
      categoryIds.add(category.id);
    }

    return categoryIds;
  }

  String printIngredients() {
    var ingredientsText = "";
    if (this.ingredients.isNotEmpty) {
      if (this.ingredients.length > 0) {
        ingredientsText = "";
        for (var i = 0; i < this.ingredients.length; i++) {
          (i + 1) < this.ingredients.length
              ? ingredientsText += this.ingredients[i].name + ", "
              : ingredientsText += this.ingredients[i].name + ", ...";
        }
        return ingredientsText;
      } else {
        return "Bisher keine Zutaten.";
      }
    } else {
      return "Zutatenliste konnte nicht gelesen werden.";
    }
  }

  static int randomBackgroundColor() {
    return (Random().nextDouble() * 0xFFFFFF).toInt();
  }
}
