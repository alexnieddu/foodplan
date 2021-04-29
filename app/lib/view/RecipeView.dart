import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/view/AddRecipeView.dart';
import 'package:foodplan/view/DetailRecipeView.dart';

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
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              Recipe recipe = snapshot.data[i];
                              // ListItem
                              return recipeGridTile(
                                  snapshot, i, context, recipe);
                            },
                          ),
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

  Container recipeGridTile(
      AsyncSnapshot snapshot, int i, BuildContext context, Recipe recipe) {
    return Container(
      // height: 100,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
          color: Color(snapshot.data[i].backgroundColor).withOpacity(0.4),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(snapshot.data[i].backgroundColor).withOpacity(.4),
                Color(snapshot.data[i].backgroundColor + colorOffset)
                    .withOpacity(.4)
              ]),
          borderRadius: BorderRadius.circular(borderradius),
          boxShadow: [constShadowDarkLight]),
      child: FlatButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailRecipeView(recipe: recipe)),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image
            Container(
                margin: EdgeInsets.only(bottom: 15),
                child: ClipRRect(
                  child: snapshot.data[i].image.isRemote
                      ? Image.network(snapshot.data[i].image.path,
                          width: 80, height: 80, fit: BoxFit.cover)
                      : Image.file(File(snapshot.data[i].image.path),
                          width: 80, height: 80, fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                )),
            // Description
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: shortenRecipeName(recipe.name),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _searchInput(String search) {
    setState(() {});
  }

  _pushDetailRevipeView(BuildContext context, Recipe recipe) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailRecipeView(recipe: recipe)))
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

  String shortenRecipeName(String recipeName) {
    const int titleLengthForGridTile = 19;
    return recipeName.length >= titleLengthForGridTile
        ? recipeName.substring(0, titleLengthForGridTile) + "..."
        : recipeName;
  }
}
