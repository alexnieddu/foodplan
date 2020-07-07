import 'package:flutter/material.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/view/AddRecipeView.dart';

class RecipeView extends StatefulWidget {
  RecipeViewState createState() => RecipeViewState();
}

class RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text("${snapshot.data[i].name}"),
                  subtitle: Text("#${i + 1}"),
                  onLongPress: () {
                    RecipeDatabase.db.deleteRecipe(snapshot.data[i].id);
                    print(
                        "${snapshot.data[i].name} was deleted from database recipe");
                    setState(() {});
                  },
                );
              },
            );
          }
        },
        future: RecipeDatabase.db.getAllRecipes(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecipeView()),
            ).then((value) {
              setState(() {});
            });
          },
          child: Icon(Icons.add)),
    );
  }
}
