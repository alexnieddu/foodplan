class Recipe {
  int id;
  String name;
  int backgroundColor;
  String image;

  Recipe.recipe(name) {
    this.name = name;
    this.backgroundColor = backgroundColor;
    this.image = image;
  }

  Recipe({this.id, this.name, this.backgroundColor, this.image});

  factory Recipe.fromMap(Map<String, dynamic> map) => new Recipe(
        id: map["id"],
        name: map["name"],
        backgroundColor: map["backgroundColor"],
        image: map["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "backgroundColor": backgroundColor,
        "image": image,
      };
}
