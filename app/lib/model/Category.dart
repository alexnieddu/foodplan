class Category {
  int id;
  String name;

  Category.category(name) {
    this.name = name;
  }

  Category({this.id, this.name});

  factory Category.fromMap(Map<String, dynamic> map) => new Category(
        id: map["id"],
        name: map["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
