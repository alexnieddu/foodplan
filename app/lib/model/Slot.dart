class Slot {
  int id;
  String name;
  int recipeId;
  String recipe;

  Slot.recipe(name) {
    this.name = name;
  }

  Slot({this.id, this.name, this.recipeId, this.recipe});

  factory Slot.fromMap(Map<String, dynamic> map) => new Slot(
      id: map["id"],
      name: map["name"],
      recipeId: map["recipeId"],
      recipe: map["recipeName"]);

  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "recipeName": recipe};
}
