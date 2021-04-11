import 'dart:io';
import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/RecipeImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';

class AddRecipeView extends StatefulWidget {
  AddRecipeViewState createState() => AddRecipeViewState();
}

class AddRecipeViewState extends State<AddRecipeView> {
  final recipeNameController = TextEditingController();
  final recipeDescriptionController = TextEditingController();
  List<Category> categories = [];
  List<Ingredient> ingredients = [];
  List<int> categoryIds = [];
  List<int> ingredientIds = [];
  File _imageFood;
  File _imageRecipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Neues Rezept"),
          iconTheme: IconThemeData(color: mainColor),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _imageFood == null
                  ? Text("Kein Bild")
                  : Container(
                      decoration: BoxDecoration(
                          boxShadow: [],
                          borderRadius: BorderRadius.circular(100)),
                      margin: EdgeInsets.only(right: 15, top: 15, bottom: 15),
                      child: ClipRRect(
                        child: Image.file(_imageFood,
                            width: 160, height: 160, fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(100),
                      )),
              TextField(
                  decoration: InputDecoration(
                    hintText: "Rezeptname",
                  ),
                  controller: recipeNameController),
              TextField(
                  decoration: InputDecoration(
                    hintText: "Bemerkung",
                  ),
                  controller: recipeDescriptionController),
              // Categories
              Container(
                height: 70,
                child: FutureBuilder(
                    future: RecipeDatabase.db.getAllCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var category = Category(
                                id: snapshot.data[index].id,
                                name: snapshot.data[index].name);
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: FilterChip(
                                label: Text(snapshot.data[index].name),
                                labelStyle: TextStyle(
                                    color: categories
                                            .where((cat) =>
                                                cat.name == category.name)
                                            .isNotEmpty
                                        ? Colors.white
                                        : Colors.black),
                                selectedColor: mainColor,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderradius)),
                                selected: categories
                                    .where((cat) => cat.name == category.name)
                                    .isNotEmpty,
                                onSelected: (bool value) {
                                  setState(() {
                                    if (value) {
                                      categories.add(category);
                                    } else {
                                      categories.removeWhere(
                                          (cat) => cat.id == category.id);
                                    }
                                    print(categories.toString());
                                  });
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              // Ingredients
              Container(
                height: 70,
                child: FutureBuilder(
                    future: RecipeDatabase.db.getAllIngredients(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var ingredient = Ingredient(
                                id: snapshot.data[index].id,
                                name: snapshot.data[index].name);
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: FilterChip(
                                label: Text(snapshot.data[index].name),
                                labelStyle: TextStyle(
                                    color: ingredients
                                            .where((ing) =>
                                                ing.name == ingredient.name)
                                            .isNotEmpty
                                        ? Colors.white
                                        : Colors.black),
                                selectedColor: mainColor,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderradius)),
                                selected: ingredients
                                    .where((ing) => ing.name == ingredient.name)
                                    .isNotEmpty,
                                onSelected: (bool value) {
                                  setState(() {
                                    if (value) {
                                      ingredients.add(ingredient);
                                    } else {
                                      ingredients.removeWhere(
                                          (ing) => ing.id == ingredient.id);
                                    }
                                    print(ingredients.toString());
                                  });
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              MaterialButton(
                color: mainColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderradius)),
                onPressed: _getImageFood,
                child: Text("Essensbild hinzufügen"),
              ),
              MaterialButton(
                color: mainColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderradius)),
                onPressed: _getImageRecipe,
                child: Text("Rezeptbild hinzufügen"),
              ),
              MaterialButton(
                color: mainColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderradius)),
                onPressed: () {
                  _saveRecipe(
                      recipeNameController.text,
                      recipeDescriptionController.text,
                      categories,
                      ingredients,
                      _imageFood.path);
                  Navigator.pop(context);
                },
                child: Text("Fertig"),
              ),
            ],
          ),
        ));
  }

  void _saveRecipe(String text, String description, List<Category> cats,
      List<Ingredient> ings, String imagePath) {
    if (text.isNotEmpty) {
      final img = RecipeImage(id: 1, path: imagePath);
      final recipe = Recipe(
          name: text,
          description: description,
          categories: cats,
          ingredients: ings,
          image: img);
      RecipeDatabase.db.insert(recipe);
    }
  }

  void _getImageFood() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile _pickedImage =
        await _picker.getImage(source: ImageSource.gallery);
    if (_pickedImage == null) return;
    var image = File(_pickedImage.path);
    setState(() {
      _imageFood = image;
    });
  }

  void _getImageRecipe() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile _pickedImage =
        await _picker.getImage(source: ImageSource.gallery);
    if (_pickedImage == null) return;
    var image = File(_pickedImage.path);
    setState(() {
      _imageRecipe = image;
    });
  }
}
