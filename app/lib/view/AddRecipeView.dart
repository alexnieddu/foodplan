import 'dart:io';
import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/RecipeImage.dart';
import 'package:foodplan/view/AddPropertyView.dart';
import 'package:foodplan/widgets/FancyText.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';

class AddRecipeView extends StatefulWidget {
  AddRecipeViewState createState() => AddRecipeViewState();
}

class AddRecipeViewState extends State<AddRecipeView> {
  final recipeNameController = TextEditingController();
  final recipeDescriptionController = TextEditingController();
  int _recipeColor;
  List<Category> categories = [];
  List<String> categoriesString = [];
  List<Ingredient> ingredients = [];
  List<int> categoryIds = [];
  List<int> ingredientIds = [];
  File _imageFood;
  File _imageRecipe;
  // int blue = 255;
  // int green = 65280;
  // int red = 16711680;
  // int yellow = 16776960;
  // int violet = 8651007;
  int red = 0xFFFF0000;
  int green = 0xFF00FF00;
  int blue = 0xFF0000FF;
  int yellow = 0xFFFFFF00;
  int violet = 0xFFFF00FF;
  String propertyType;

  double _imageSize = 160.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FancyText("Rezept anlegen"),
          iconTheme: IconThemeData(color: mainColor),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        boxShadow: [],
                        borderRadius: BorderRadius.circular(100)),
                    margin: EdgeInsets.only(right: 15, top: 15, bottom: 15),
                    child: Center(
                      child: FlatButton(
                        onPressed: _getImageFood,
                        child: ClipRRect(
                          child: _imageFood != null
                              ? Image.file(_imageFood,
                                  width: _imageSize,
                                  height: _imageSize,
                                  fit: BoxFit.cover)
                              : Image(
                                  width: _imageSize,
                                  height: _imageSize,
                                  image:
                                      AssetImage("assets/workinprogress.jpg"),
                                  fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    )),
                TextField(
                    decoration: InputDecoration(
                      hintText: "Rezeptname",
                    ),
                    controller: recipeNameController),
                MaterialButton(
                  color: mainColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderradius)),
                  onPressed: _getImageRecipe,
                  child: Text("Bild vom Rezept"),
                ),
                TextField(
                    decoration: InputDecoration(hintText: "Bemerkung"),
                    controller: recipeDescriptionController),
                // Category
                Row(
                  children: [
                    IconButton(
                        color: mainColor,
                        iconSize: 35.0,
                        icon: Icon(Icons.add_circle_rounded),
                        onPressed: addCategory),
                    Text("Kategorien")
                  ],
                ),
                // Ingredient
                Row(
                  children: [
                    IconButton(
                        color: mainColor,
                        iconSize: 35.0,
                        icon: Icon(Icons.add_circle_rounded),
                        onPressed: addIngredient),
                    Text("Zutaten")
                  ],
                ),
                // Color
                Row(
                  children: [
                    IconButton(
                        color: mainColor,
                        iconSize: 35.0,
                        icon: Icon(Icons.add_circle_rounded),
                        onPressed: addIngredient),
                    Text("Farbe")
                  ],
                ),
                // Categories
                // Text("Kategorien:"),
                // Container(
                //   height: 70,
                //   child: FutureBuilder(
                //       future: RecipeDatabase.db.getAllCategories(),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           return ListView.builder(
                //             padding: EdgeInsets.symmetric(horizontal: 20),
                //             scrollDirection: Axis.horizontal,
                //             itemCount: snapshot.data.length + 1,
                //             itemBuilder: (context, index) {
                //               if (index == 0) {
                //                 return TextButton(
                //                   onPressed: addCategory,
                //                   child: Icon(Icons.add),
                //                   style: ButtonStyle(
                //                       shape: MaterialStateProperty.all<
                //                               RoundedRectangleBorder>(
                //                           RoundedRectangleBorder(
                //                               borderRadius:
                //                                   BorderRadius.circular(18.0),
                //                               side: BorderSide(
                //                                   color: mainColor)))),
                //                 );
                //               } else {
                //                 var category = Category(
                //                     id: snapshot.data[index - 1].id,
                //                     name: snapshot.data[index - 1].name);
                //                 return Container(
                //                   padding: EdgeInsets.symmetric(horizontal: 5),
                //                   child: FilterChip(
                //                     label: Text(snapshot.data[index - 1].name),
                //                     labelStyle: TextStyle(
                //                         color: categories
                //                                 .where((cat) =>
                //                                     cat.name == category.name)
                //                                 .isNotEmpty
                //                             ? Colors.white
                //                             : Colors.black),
                //                     selectedColor: mainColor,
                //                     backgroundColor: Colors.white,
                //                     shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(
                //                             borderradius)),
                //                     selected: categories
                //                         .where(
                //                             (cat) => cat.name == category.name)
                //                         .isNotEmpty,
                //                     onSelected: (bool value) {
                //                       setState(() {
                //                         if (value) {
                //                           categories.add(category);
                //                         } else {
                //                           categories.removeWhere(
                //                               (cat) => cat.id == category.id);
                //                         }
                //                         print(categories.toString());
                //                       });
                //                     },
                //                   ),
                //                 );
                //               }
                //             },
                //           );
                //         } else {
                //           return Center(child: CircularProgressIndicator());
                //         }
                //       }),
                // ),
                // Ingredients
                // Text("Zutaten:"),
                // Container(
                //   height: 70,
                //   child: FutureBuilder(
                //       future: RecipeDatabase.db.getAllIngredients(),
                //       builder: (context, snapshot) {
                //         if (snapshot.hasData) {
                //           return ListView.builder(
                //             padding: EdgeInsets.symmetric(horizontal: 20),
                //             scrollDirection: Axis.horizontal,
                //             itemCount: snapshot.data.length + 1,
                //             itemBuilder: (context, index) {
                //               if (index == 0) {
                //                 return TextButton(
                //                   onPressed: addIngredient,
                //                   child: Icon(Icons.add),
                //                   style: ButtonStyle(
                //                       shape: MaterialStateProperty.all<
                //                               RoundedRectangleBorder>(
                //                           RoundedRectangleBorder(
                //                               borderRadius:
                //                                   BorderRadius.circular(18.0),
                //                               side: BorderSide(
                //                                   color: mainColor)))),
                //                 );
                //               } else {
                //                 var ingredient = Ingredient(
                //                     id: snapshot.data[index - 1].id,
                //                     name: snapshot.data[index - 1].name);
                //                 return Container(
                //                   padding: EdgeInsets.symmetric(horizontal: 5),
                //                   child: FilterChip(
                //                     label: Text(snapshot.data[index - 1].name),
                //                     labelStyle: TextStyle(
                //                         color: ingredients
                //                                 .where((ing) =>
                //                                     ing.name == ingredient.name)
                //                                 .isNotEmpty
                //                             ? Colors.white
                //                             : Colors.black),
                //                     selectedColor: mainColor,
                //                     backgroundColor: Colors.white,
                //                     shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(
                //                             borderradius)),
                //                     selected: ingredients
                //                         .where((ing) =>
                //                             ing.name == ingredient.name)
                //                         .isNotEmpty,
                //                     onSelected: (bool value) {
                //                       setState(() {
                //                         if (value) {
                //                           ingredients.add(ingredient);
                //                         } else {
                //                           ingredients.removeWhere(
                //                               (ing) => ing.id == ingredient.id);
                //                         }
                //                         print(ingredients.toString());
                //                       });
                //                     },
                //                   ),
                //                 );
                //               }
                //             },
                //           );
                //         } else {
                //           return Center(child: CircularProgressIndicator());
                //         }
                //       }),
                // ),
                // Color selection
                // Text("Farbe:"),
                // Column(
                //   children: <Widget>[
                //     ListTile(
                //       title: Text("zufällig"),
                //       leading: Radio(
                //         value: -1,
                //         groupValue: _recipeColor,
                //         onChanged: (int value) {
                //           setState(() {
                //             _recipeColor = -1;
                //           });
                //         },
                //       ),
                //     ),
                //     ListTile(
                //       title: Text("blau"),
                //       leading: Radio(
                //         value: blue,
                //         groupValue: _recipeColor,
                //         onChanged: (int value) {
                //           setState(() {
                //             _recipeColor = value;
                //           });
                //         },
                //       ),
                //     ),
                //     ListTile(
                //       title: Text("rot"),
                //       leading: Radio(
                //         value: red,
                //         groupValue: _recipeColor,
                //         onChanged: (int value) {
                //           setState(() {
                //             _recipeColor = value;
                //           });
                //         },
                //       ),
                //     ),
                //     ListTile(
                //       title: Text("grün"),
                //       leading: Radio(
                //         value: green,
                //         groupValue: _recipeColor,
                //         onChanged: (int value) {
                //           setState(() {
                //             _recipeColor = value;
                //           });
                //         },
                //       ),
                //     ),
                //     ListTile(
                //       title: Text("gelb"),
                //       leading: Radio(
                //         value: yellow,
                //         groupValue: _recipeColor,
                //         onChanged: (int value) {
                //           setState(() {
                //             _recipeColor = value;
                //           });
                //         },
                //       ),
                //     ),
                //     ListTile(
                //       title: Text("lila"),
                //       leading: Radio(
                //         value: violet,
                //         groupValue: _recipeColor,
                //         onChanged: (int value) {
                //           setState(() {
                //             _recipeColor = value;
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                MaterialButton(
                  color: mainColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderradius)),
                  onPressed: () {
                    print("DSADSADSA: " + categoriesString.toString());
                    // _saveRecipe(
                    //     recipeNameController.text,
                    //     recipeDescriptionController.text,
                    //     categories,
                    //     ingredients,
                    //     _imageFood.path,
                    //     _imageRecipe.path);
                    // Navigator.pop(context);
                  },
                  child: Text("Fertig"),
                ),
              ],
            ),
          ),
        ));
  }

  void _saveRecipe(String text, String description, List<Category> cats,
      List<Ingredient> ings, String imagePath, String descImgPath) {
    if (text.isNotEmpty) {
      final img = RecipeImage(path: imagePath);
      final descImg = RecipeImage(path: descImgPath);
      _recipeColor == -1 ?? Recipe.randomBackgroundColor();
      final recipe = Recipe(
          name: text,
          description: description,
          backgroundColor: _recipeColor,
          categories: cats,
          ingredients: ings,
          image: img,
          descriptionImage: descImg);
      RecipeDatabase.db.create(recipe);
    }
  }

  void _getImageFood() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile _pickedImage =
        await _picker.getImage(source: ImageSource.gallery);
    if (_pickedImage == null) return;
    var image = File(_pickedImage.path);
    setState(() {
      _imageFood = image;
    });
  }

  void _getImageRecipe() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile _pickedImage =
        await _picker.getImage(source: ImageSource.gallery);
    if (_pickedImage == null) return;
    var image = File(_pickedImage.path);
    setState(() {
      _imageRecipe = image;
    });
  }

  void addCategory() {
    propertyType = "Kategorien";
    _pushView(context);
  }

  void addIngredient() {
    propertyType = "Zutaten";
    _pushView(context);
  }

  _pushView(BuildContext context) async {
    final retreiveData = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddPropertyView(propertyTypeName: propertyType)));

    categoriesString = retreiveData;
    // print(retreiveData.toString());
  }
}
