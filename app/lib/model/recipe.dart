import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Recipe {
  int id;
  String name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": name
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Recipe.recipe(name) {
    this.name = name;
  }

  Recipe({this.id, this.name});

  Recipe.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
  }
}

class RecipeProvider{
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''create table recipe (
          id integer primary key autoincrement,
          name text not null
        )''');
      });
  }

  Future<Recipe> insert(Recipe recipe) async {
    recipe.id = await db.insert("recipe", recipe.toMap());
    return recipe;
  }

  Future<Recipe> getRecipe(int id) async {
    List<Map> maps = await db.query("recipe",
      columns: ["id", "name"],
      where: "id = ?",
      whereArgs: [id]);
    if (maps.length > 0) {
      return Recipe.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Recipe>> getAllRecipe() async {
    List<Map<String, dynamic>> maps = await db.query("recipe",
      columns: ["id", "name"]);
      
      return List.generate(maps.length, (index) {
        return Recipe(
          id: maps[index]["id"],
          name: maps[index]["name"],
        );
      });
  }

  Future<int> delete(int id) async {
    return await db.delete("recipe", where: "id = ?", whereArgs: [id]);
  }

  Future<int> update(Recipe recipe) async {
    return await db.update("recipe", recipe.toMap(),
      where: "id = ?", whereArgs: [recipe.id]);
  }

  Future close() async => db.close();
}