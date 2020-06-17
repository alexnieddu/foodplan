class Recipe {
  String name;
  List<String> ingredients;
  List<String> categories;
  String imageURL;

  Recipe(name, ingredients, categories, imageURL) {
    this.name = name;
    this.ingredients = ingredients;
    this.categories = categories;
    this.imageURL = imageURL;
  }
}