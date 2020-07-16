import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/view/AddRecipeView.dart';

class RecipeView extends StatefulWidget {
  RecipeViewState createState() => RecipeViewState();
}

class RecipeViewState extends State<RecipeView> {
  final searchPhraseController = TextEditingController();
  String searchPhrase = "";
  List cats = ["Alles", "Fleisch", "Suppe", "Vegetarisch", "Frühstück"];
  List selectedCats = [];
  List<int> selectedCatsIds = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Menubar
          Container(
            decoration:
                BoxDecoration(color: mainColor, boxShadow: [constShadowDark]),
            child: Column(
              children: <Widget>[
                // Searchbar
                Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [constShadowDark]),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.search, color: mainColor),
                          hintText: "Suche",
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
                        if(snapshot.hasData) {
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: FilterChip(
                                  label: Text(snapshot.data[index].name),
                                  labelStyle: TextStyle(
                                      color: selectedCats
                                              .contains(snapshot.data[index].name)
                                          ? Colors.black
                                          : Colors.white),
                                  selectedColor: Colors.white,
                                  backgroundColor: mainColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  selected:
                                      selectedCats.contains(snapshot.data[index].name),
                                  onSelected: (bool value) {
                                    setState(() {
                                      if (value) {
                                        selectedCatsIds.add(snapshot.data[index].id);
                                        selectedCats.add(snapshot.data[index].name);
                                      }
                                      else {
                                        selectedCatsIds.remove(snapshot.data[index].id);
                                        selectedCats.remove(snapshot.data[index].name);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        }
                        else {
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
              height: 450,
              child: FutureBuilder(
                future: RecipeDatabase.db
                    .getRecipesForSearch(searchPhraseController.text),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Scrollbar(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: Icon(Icons.fastfood),
                            title: Text("${snapshot.data[i].name}"),
                            subtitle: Text("#${i + 1}"),
                            onLongPress: () {
                              RecipeDatabase.db
                                  .deleteRecipe(snapshot.data[i].id);
                              print(
                                  "${snapshot.data[i].name} was deleted from database recipe");
                              setState(() {});
                            },
                          );
                        },
                      ),
                    );
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
}
