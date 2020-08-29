import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/RecipeImage.dart';

class Recipe {
  int id;
  String name;
  int backgroundColor;
  RecipeImage image;
  List<Category> categories;
  List<Ingredient> ingredients;

  Recipe({this.id, this.name, this.backgroundColor, this.image});

  factory Recipe.fromMap(Map<String, dynamic> map) => new Recipe(
      id: map["id"],
      name: map["name"],
      backgroundColor: map["backgroundColor"],
      image: RecipeImage(id: map["imageId"], path: null));

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "backgroundColor": backgroundColor,
        "image": {"id": image.id, "path": image.path},
      };
}
