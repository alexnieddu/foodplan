import 'package:flutter/material.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';

class AddRecipeView extends StatelessWidget {
  final recipeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new recipe"),
        ),
        body: Center(child: 
          Column(
            children: <Widget>[
              Expanded(child: TextField(controller: recipeNameController)),
              MaterialButton(
                onPressed: () {
                  _saveRecipe(recipeNameController.text);
                  Navigator.pop(context);
                },
                child: Text("Save"),
              )
            ],
          )
        ));
  }

  void _saveRecipe(String text) {
    Recipe newRecipe = Recipe.recipe(text);
    RecipeDatabase.db.newRecipe(newRecipe);
  }
}
