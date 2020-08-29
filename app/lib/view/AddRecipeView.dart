import 'dart:io';
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
  List<int> categoryIds = [];
  List<int> ingredientIds = [];
  File _image;

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
              _image == null
                  ? Text("Kein Bild")
                  : Container(
                      decoration: BoxDecoration(
                          boxShadow: [],
                          borderRadius: BorderRadius.circular(100)),
                      margin: EdgeInsets.only(right: 15, top: 15, bottom: 15),
                      child: ClipRRect(
                        child: Image.file(_image,
                            width: 160, height: 160, fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(100),
                      )),
              TextField(
                  decoration: InputDecoration(
                    hintText: "Rezepte",
                  ),
                  controller: recipeNameController),
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
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: FilterChip(
                                label: Text(snapshot.data[index].name),
                                labelStyle: TextStyle(
                                    color: categoryIds
                                            .contains(snapshot.data[index].id)
                                        ? Colors.white
                                        : Colors.black),
                                selectedColor: mainColor,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderradius)),
                                selected: categoryIds
                                    .contains(snapshot.data[index].id),
                                onSelected: (bool value) {
                                  setState(() {
                                    if (value) {
                                      categoryIds.add(snapshot.data[index].id);
                                    } else {
                                      categoryIds
                                          .remove(snapshot.data[index].id);
                                    }
                                    print(categoryIds);
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
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: FilterChip(
                                label: Text(snapshot.data[index].name),
                                labelStyle: TextStyle(
                                    color: ingredientIds
                                            .contains(snapshot.data[index].id)
                                        ? Colors.white
                                        : Colors.black),
                                selectedColor: mainColor,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderradius)),
                                selected: ingredientIds
                                    .contains(snapshot.data[index].id),
                                onSelected: (bool value) {
                                  setState(() {
                                    if (value) {
                                      ingredientIds
                                          .add(snapshot.data[index].id);
                                    } else {
                                      ingredientIds
                                          .remove(snapshot.data[index].id);
                                    }
                                    print(ingredientIds);
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
                onPressed: _getImage,
                child: Text("Foto hinzufügen"),
              ),
              MaterialButton(
                color: mainColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderradius)),
                onPressed: () {
                  _saveRecipe(
                      recipeNameController.text, categoryIds, _image.path);
                  Navigator.pop(context);
                },
                child: Text("Rezept hinzufügen"),
              ),
            ],
          ),
        ));
  }

  void _saveRecipe(String text, List<int> categoryIds, String imagePath) {
    if (text.isNotEmpty) {
      RecipeDatabase.db
          .newRecipe(text, categoryIds, ingredientIds, imagePath);
    }
  }

  void _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile _pickedImage =
        await _picker.getImage(source: ImageSource.gallery);
    if (_pickedImage == null) return;
    var image = File(_pickedImage.path);
    setState(() {
      _image = image;
    });
  }
}
