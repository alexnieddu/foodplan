class Recipe {
  int id;
  String name;
  int backgroundColor;
  int imageId;

  Recipe.recipe(name) {
    this.name = name;
    this.backgroundColor = backgroundColor;
    this.imageId = imageId;
  }

  Recipe({this.id, this.name, this.backgroundColor, this.imageId});

  factory Recipe.fromMap(Map<String, dynamic> map) => new Recipe(
        id: map["id"],
        name: map["name"],
        backgroundColor: map["backgroundColor"],
        imageId: map["imageId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "backgroundColor": backgroundColor,
        "imageId": imageId,
      };
}
