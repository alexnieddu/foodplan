class Slot {
  int id;
  String name;
  String recipe;

  Slot.recipe(name) {
    this.name = name;
  }

  Slot({this.id, this.name, this.recipe});

  factory Slot.fromMap(Map<String, dynamic> map) => new Slot(
        id: map["id"],
        name: map["name"],
        recipe: map["recipe"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "recipe": recipe
      };
}
