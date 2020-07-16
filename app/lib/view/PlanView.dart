import 'package:flutter/material.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/data/RecipeDatabase.dart';

class PlanView extends StatefulWidget {
  PlanViewState createState() => PlanViewState();
}

class PlanViewState extends State<PlanView> {
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
                      leading: Icon(Icons.calendar_today),
                      title: Text(slots.data[i].name),
                      subtitle: Text(slots.data[i].recipe),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                              onPressed: () {
                                RecipeDatabase.db
                                    .getRnd(slots.data[i].recipeId)
                                    .then((rndRecipe) {
                                  RecipeDatabase.db.updateSlot(
                                      rndRecipe.first.id, slots.data[i].id);
                                  setState(() {});
                                });
                              },
                              icon: Icon(Icons.refresh)),
                          /* IconButton(
                              icon: Icon(Icons.more_vert), onPressed: null) */
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
      RecipeDatabase.db.updateSlot(rndRecipe.first.id, slotID);
      setState(() {});
    });
  }
}
