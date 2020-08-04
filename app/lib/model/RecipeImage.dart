class RecipeImage {
  int id;
  String path;

  RecipeImage.recipeImage(path) {
    this.path = path;
  }

  RecipeImage({this.id, this.path});

  factory RecipeImage.fromMap(Map<String, dynamic> map) => new RecipeImage(
        id: map["id"],
        path: map["path"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "path": path,
      };
}
