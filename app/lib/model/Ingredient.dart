class Ingredient {
  int id;
  String name;

  Ingredient.ingredient(name) {
    this.name = name;
  }

  Ingredient({this.id, this.name});

  factory Ingredient.fromMap(Map<String, dynamic> map) => new Ingredient(
        id: map["id"],
        name: map["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
