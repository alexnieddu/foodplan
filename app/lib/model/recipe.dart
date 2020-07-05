class Recipe {
  int id;
  String name;

  Recipe.recipe(name) {
    this.name = name;
  }

  Recipe({this.id, this.name});

  factory Recipe.fromMap(Map<String, dynamic> map) => new Recipe(
        id: map["id"],
        name: map["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
