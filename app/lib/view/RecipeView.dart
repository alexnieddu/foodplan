import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/view/AddRecipeView.dart';
import 'package:foodplan/view/DetailRecipeView.dart';
import 'package:path/path.dart';

List rndPix = [
  "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?ixlib=rb-1.2.1&w=1000&q=80"
];

class RecipeView extends StatefulWidget {
  RecipeViewState createState() => RecipeViewState();
}

class RecipeViewState extends State<RecipeView> {
  final searchPhraseController = TextEditingController();
  String searchPhrase = "";
  List<String> selectedCats = [];
  List<int> selectedCatsIds = [];

  var _searchBoxShadow = constShadowDarkLight;
  var _focusSearchTextField = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusSearchTextField.addListener(_onFocusSearchTextfield);
  }

  @override
  void dispose() {
    _focusSearchTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Menubar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0),
            ),
            child: Column(
              children: <Widget>[
                // Searchbar
                AnimatedContainer(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(borderradius),
                        boxShadow: [_searchBoxShadow]),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInExpo,
                    child: TextField(
                      autofocus: false,
                      focusNode: _focusSearchTextField,
                      decoration: InputDecoration(
                          icon: Icon(Icons.search, color: mainColor),
                          hintText: "Rezepte, Zutaten, ...",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      onChanged: _searchInput,
                      controller: searchPhraseController,
                    )),
                // Categories
                Container(
                  height: 70,
                  margin: EdgeInsets.all(0),
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
                                      color: selectedCats.contains(
                                              snapshot.data[index].name)
                                          ? Colors.white
                                          : Colors.black),
                                  selectedColor: mainColor,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(borderradius)),
                                  selected: selectedCats
                                      .contains(snapshot.data[index].name),
                                  onSelected: (bool value) {
                                    setState(() {
                                      if (value) {
                                        selectedCatsIds
                                            .add(snapshot.data[index].id);
                                        selectedCats
                                            .add(snapshot.data[index].name);
                                      } else {
                                        selectedCatsIds
                                            .remove(snapshot.data[index].id);
                                        selectedCats
                                            .remove(snapshot.data[index].name);
                                      }
                                      _searchInput("dummy");
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
              ],
            ),
          ),
          // RecipeList
          Expanded(
            flex: 1,
            child: Container(
              child: FutureBuilder(
                future: RecipeDatabase.db.getRecipesForSearch(
                    searchPhraseController.text, selectedCats),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.length == 0) {
                      return Center(child: Text("Keine Rezepte gefunden."));
                    } else {
                      return Scrollbar(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            Recipe recipe = snapshot.data[i];
                            int rndIndex = Random().nextInt(rndPix.length);
                            // ListItem
                            return Container(
                              // height: 100,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Color(snapshot.data[i].backgroundColor)
                                      .withOpacity(.4),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(snapshot.data[i].backgroundColor)
                                            .withOpacity(.4),
                                        Color(snapshot.data[i].backgroundColor +
                                                colorOffset)
                                            .withOpacity(.4)
                                      ]),
                                  borderRadius:
                                      BorderRadius.circular(borderradius),
                                  boxShadow: [constShadowDarkLight]),
                              child: FlatButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailRecipeView(
                                            recipeId: snapshot.data[i].id)),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                onLongPress: () {
                                  RecipeDatabase.db
                                      .deleteRecipe(snapshot.data[i].id);
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Image
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: 15, top: 15, bottom: 15),
                                        child: ClipRRect(
                                          child: snapshot.data[i].image.path !=
                                                  null
                                              ? Image.file(
                                                  File(snapshot
                                                      .data[i].image.path),
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover)
                                              : Image.network(rndPix[rndIndex],
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                    // Description
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 165),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Title
                                          RichText(
                                            text: TextSpan(
                                                text: "${recipe.name}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                )),
                                          ),
                                          // Ingredients
                                          // Text(recipe.printIngredients())
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    // Icon
                                    IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: () {
                                          print("h");
                                        })
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          )
        ],
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

  void _searchInput(String search) {
    setState(() {});
  }

  _pushDetailRevipeView(BuildContext context, int recipeId) {
    Navigator.push(
            context,
            // TODO: Pass Recipe object, NOT recipeID !!!
            MaterialPageRoute(
                builder: (context) => DetailRecipeView(recipeId: recipeId)))
        .then((value) {
      setState(() {});
    });
  }

  void _onFocusSearchTextfield() {
    // Set box shadow
    _focusSearchTextField.hasFocus
        ? _searchBoxShadow = constShadow
        : _searchBoxShadow = constShadowDarkLight;
    setState(() {});
  }
}
