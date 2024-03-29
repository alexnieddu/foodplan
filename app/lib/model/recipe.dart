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
  RecipeImage descriptionImage;
  List<Category> categories;
  List<Ingredient> ingredients;
  bool isPublic;
  bool isFavorite;

  Recipe(
      {this.id,
      this.name,
      this.description,
      this.backgroundColor,
      this.image,
      this.descriptionImage,
      this.categories,
      this.ingredients,
      this.isPublic,
      this.isFavorite});

  factory Recipe.fromMap(Map<String, dynamic> map) => Recipe(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      backgroundColor: map["backgroundColor"],
      // NEED REWORK
      image: RecipeImage(id: map["imageId"], path: null, isRemote: false),
      descriptionImage:
          RecipeImage(id: map["imageId"], path: null, isRemote: false),
      categories: [],
      ingredients: []);

  factory Recipe.fromMapApi(Map<String, dynamic> map) => Recipe(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      backgroundColor: map["backgroundColor"],
      image: RecipeImage(
          id: map["image"]["id"], path: map["image"]["path"], isRemote: true),
      descriptionImage: RecipeImage(
          id: map["descriptionImage"]["id"],
          path: map["descriptionImage"]["path"],
          isRemote: true,
          isDescriptionImage: true),
      categories: List<Category>.from(
          map["categories"].map((category) => Category.fromMap(category))),
      ingredients: List<Ingredient>.from(map["ingredients"]
          .map((ingredient) => Ingredient.fromMap(ingredient))),
      isPublic: map["isPublic"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "backgroundColor": backgroundColor,
        "image": {
          "id": image.id,
          "path": image.path,
          "isDescriptionImage": image.isDescriptionImage,
          "isRemote": image.isRemote
        },
        "descriptionImage": {
          "id": image.id,
          "path": image.path,
          "isDescriptionImage": image.isDescriptionImage,
          "isRemote": image.isRemote
        },
        "categories":
            List<dynamic>.from(categories.map((category) => category.toMap())),
        "ingredients": List<dynamic>.from(
            ingredients.map((ingredient) => ingredient.toMap()))
      };

  List<int> getCategoryIds() {
    List<int> categoryIds = [];

    for (var category in this.categories) {
      categoryIds.add(category.id);
    }

    return categoryIds;
  }

  List<String> getCategories() {
    List<String> categoryString = [];

    for (var category in this.categories) {
      categoryString.add(category.name);
    }

    return categoryString;
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
