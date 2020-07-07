import 'package:flutter/material.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/data/RecipeDatabase.dart';

final List<String> week = [
  "Montag",
  "Dienstag",
  "Mittwoch",
  "Donnerstag",
  "Freitag",
  "Samstag",
  "Sonntag"
];

class PlanView extends StatefulWidget {
  PlanViewState createState() => PlanViewState();
}

class PlanViewState extends State<PlanView> {
  List<Recipe> recipes = [
    Recipe.recipe("Lade zuerst Rezepte"),
    Recipe.recipe("Lade zuerst Rezepte"),
    Recipe.recipe("Lade zuerst Rezepte"),
    Recipe.recipe("Lade zuerst Rezepte"),
    Recipe.recipe("Lade zuerst Rezepte"),
    Recipe.recipe("Lade zuerst Rezepte"),
    Recipe.recipe("Lade zuerst Rezepte")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          for (var i = 0; i < week.length; i++)
            ListTile(
                title: Text(recipes[i].name),
                subtitle: Text(week[i]),
                trailing: Column(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          RecipeDatabase.db
                              .getRnd(recipes[i].id)
                              .then((rndRecipe) {
                            print(rndRecipe.first.name);
                            recipes[i] = rndRecipe.first;
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.refresh)),
                  ],
                ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _reloadAllSlots(recipeID: recipes[0].id, slotID: 0);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  _reloadAllSlots({int recipeID, int slotID}) {
    for (var i = 0; i < week.length; i++) {
      RecipeDatabase.db.getRnd(recipes[i].id).then((rndRecipe) {
        recipes[i] = rndRecipe.first;
        setState(() {});
      });
    }
  }
}
