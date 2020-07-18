class Recipe {
  int id;
  String name;
  int backgroundColor;

  Recipe.recipe(name) {
    this.name = name;
    this.backgroundColor = backgroundColor;
  }

  Recipe({this.id, this.name, this.backgroundColor});

  factory Recipe.fromMap(Map<String, dynamic> map) => new Recipe(
        id: map["id"],
        name: map["name"],
        backgroundColor: map["backgroundColor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "backgroundColor": backgroundColor,
      };
}
