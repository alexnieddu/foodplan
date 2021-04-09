class RecipeImage {
  int id;
  String path;
  bool isDescriptionImage;
  bool isRemote;

  RecipeImage.recipeImage(path) {
    this.path = path;
  }

  RecipeImage({this.id, this.path, this.isDescriptionImage, this.isRemote});

  factory RecipeImage.fromMap(Map<String, dynamic> map) => new RecipeImage(
        id: map["id"],
        path: map["path"],
        isDescriptionImage: map["isDescriptionImage"],
        isRemote: map["isRemote"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "path": path,
        "isDescriptionImage": isDescriptionImage,
        "isRemote": isRemote,
      };
}
