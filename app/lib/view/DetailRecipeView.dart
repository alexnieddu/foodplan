import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/widgets/TaggedBox.dart';
import 'package:path/path.dart';

List rndPix = [
  "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?ixlib=rb-1.2.1&w=1000&q=80"
];

class DetailRecipeView extends StatefulWidget {
  final int recipeId;
  Recipe recipe;
  DetailRecipeView({Key key, int this.recipeId}) : super(key: key);
  DetailRecipeViewState createState() => DetailRecipeViewState();
}

class DetailRecipeViewState extends State<DetailRecipeView> {
  // widget.recipeId

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: RecipeDatabase.db.getRecipe(widget.recipeId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int rndIndex = Random().nextInt(rndPix.length);
              Recipe recipe = snapshot.data;
              return Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(70)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(snapshot.data.backgroundColor)
                                      .withOpacity(.4),
                                  Color(snapshot.data.backgroundColor +
                                          colorOffset)
                                      .withOpacity(.4)
                                ]),
                            // color: Color(snapshot.data.backgroundColor)
                            //     .withOpacity(.4),
                            boxShadow: [constShadowDarkLight]),
                        height: 320,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 40),
                            Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                                Spacer(),
                                IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: null)
                              ],
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [],
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      margin: EdgeInsets.only(
                                          right: 15, top: 0, bottom: 15),
                                      child: ClipRRect(
                                        child: snapshot.data.image.path != null
                                            ? Image.file(
                                                File(snapshot.data.image.path),
                                                width: 160,
                                                height: 160,
                                                fit: BoxFit.cover)
                                            : Image.network(rndPix[rndIndex],
                                                width: 160,
                                                height: 160,
                                                fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )),
                                  RichText(
                                    text: TextSpan(
                                        text: snapshot.data.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 25,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    // Body
                    Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Instruction
                            RichText(
                              text: TextSpan(
                                  text: "Beschreibung",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                            ),
                            SizedBox(height: 15),
                            snapshot.data.description != null
                                ? Text(snapshot.data.description)
                                : Text(""),
                            SizedBox(height: 20),
                            // Ingredients
                            RichText(
                              text: TextSpan(
                                  text: "Zutaten",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                for (var i = 0;
                                    i < snapshot.data.ingredients.length;
                                    i++)
                                  TaggedBox(
                                      text: snapshot.data.ingredients[i].name)
                              ],
                            ),
                            SizedBox(height: 20),
                            // Categories
                            RichText(
                              text: TextSpan(
                                  text: "Kategorien",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  )),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                for (var i = 0;
                                    i < snapshot.data.categories.length;
                                    i++)
                                  TaggedBox(
                                      text: snapshot.data.categories[i].name)
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
