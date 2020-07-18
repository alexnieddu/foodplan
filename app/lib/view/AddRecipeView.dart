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
              TextField(
                  decoration: InputDecoration(
                    hintText: "Rezepte",
                  ),
                  controller: recipeNameController
              ),
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
              MaterialButton(
                color: mainColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderradius)),
                onPressed: () {
                  _saveRecipe(recipeNameController.text, categoryIds);
                  Navigator.pop(context);
                },
                child: Text("Rezept hinzufügen"),
              ),
            ],
          ),
        ));
  }

  void _saveRecipe(String text, List<int> categoryIds) {
    if(text.isNotEmpty) {
      Recipe newRecipe = Recipe.recipe(text);
      RecipeDatabase.db.newRecipe(newRecipe, categoryIds);
    }
  }
}
