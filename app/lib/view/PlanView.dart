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
        body: FutureBuilder(
          builder: (context, slots) {
            if (!slots.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: slots.data.length,
                itemBuilder: (context, i) {
                  return ListTile(
                      title: Text(slots.data[i].name),
                      subtitle: Text(slots.data[i].recipe),
                      trailing: Column(
                        children: <Widget>[
                          IconButton(
                              onPressed: () {
                                RecipeDatabase.db.getRnd(0).then((rndRecipe) {
                                  RecipeDatabase.db.updateSlot(
                                      rndRecipe.first.name, slots.data[i].id);
                                  setState(() {});
                                });
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ));
                },
              );
            }
          },
          future: RecipeDatabase.db.getAllSlots(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RecipeDatabase.db.getAllSlots().then((value) {
              value.forEach((element) {
                _reloadAllSlots(recipeID: 0, slotID: element.id);
              });
            });
          },
          child: Icon(Icons.refresh),
        ));
  }

  _reloadAllSlots({int recipeID, int slotID}) {
    RecipeDatabase.db.getRnd(recipeID).then((rndRecipe) {
      RecipeDatabase.db.updateSlot(rndRecipe.first.name, slotID);
      setState(() {});
    });
  }
}
