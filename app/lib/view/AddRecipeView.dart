import 'dart:io';
import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/model/RecipeImage.dart';
import 'package:foodplan/view/AddCategoryView.dart';
import 'package:foodplan/view/AddIngredientView.dart';
import 'package:foodplan/view/selectColorView.dart';
import 'package:foodplan/widgets/FancyText.dart';
import 'package:foodplan/widgets/TaggedBox.dart';
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
  List<Category> categories = [];
  List<String> categoriesString;
  List<String> ingredientsString;
  List<Ingredient> ingredients = [];
  List<int> categoryIds = [];
  List<int> ingredientIds = [];
  File _imageFood;
  File _imageRecipe;
  int _recipeColor = -1;
  int red = 0xFFFF0000;
  int green = 0xFF00FF00;
  int blue = 0xFF0000FF;
  int yellow = 0xFFFFFF00;
  int violet = 0xFFFF00FF;
  String propertyType;

  double _imageSize = 160.0;

  @override
  void initState() {
    super.initState();
    categoriesString = [];
    ingredientsString = [];
  }

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
                    Text("Kategorien:"),
                    Spacer(),
                    IconButton(icon: Icon(Icons.add), onPressed: addCategory),
                  ],
                ),
                Container(
                  height: 33.0,
                  child: categoriesString.isEmpty
                      ? Center(child: Text("Noch leer..."))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoriesString == null
                              ? 0
                              : categoriesString.length,
                          itemBuilder: (context, i) {
                            return TaggedBox(text: categoriesString[i]);
                          }),
                ),
                // Ingredient
                Row(
                  children: [
                    Text("Zutaten:"),
                    Spacer(),
                    IconButton(icon: Icon(Icons.add), onPressed: addIngredient),
                  ],
                ),
                Container(
                  height: 33.0,
                  child: ingredientsString.isEmpty
                      ? Center(child: Text("Noch leer..."))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ingredientsString == null
                              ? 0
                              : ingredientsString.length,
                          itemBuilder: (context, i) {
                            return TaggedBox(text: ingredientsString[i]);
                          }),
                ),
                // Color selection
                Row(
                  children: [
                    Text("Farbe:"),
                    IconButton(
                        icon: Icon(Icons.circle),
                        onPressed: () {},
                        color: Color(_recipeColor)),
                    Spacer(),
                    IconButton(icon: Icon(Icons.add), onPressed: addColor),
                  ],
                ),
                // FINISH
                MaterialButton(
                  color: mainColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderradius)),
                  onPressed: () {
                    List<Category> cats = [];
                    categoriesString.forEach((element) {
                      cats.add(Category(name: element));
                    });

                    List<Ingredient> ings = [];
                    ingredientsString.forEach((element) {
                      ings.add(Ingredient(name: element));
                    });

                    print(recipeNameController.text);
                    print(recipeDescriptionController.text);
                    print(cats.toString());
                    print(ings.toString());
                    print(_imageFood.path);
                    print(_imageRecipe.path);
                    print(_recipeColor);

                    _saveRecipe(
                        recipeNameController.text,
                        recipeDescriptionController.text,
                        cats,
                        ings,
                        _imageFood.path,
                        _imageRecipe.path);
                    Navigator.pop(context);
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
    _pushViewCategory(context);
  }

  void addIngredient() {
    propertyType = "Zutaten";
    _pushViewIngredient(context);
  }

  void addColor() {
    propertyType = "Zutaten";
    _pushViewColor(context);
  }

  _pushViewCategory(BuildContext context) async {
    final retreiveData = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddCategoryView(
                propertyTypeName: propertyType,
                selectedCatsFrom: categoriesString)));

    categoriesString = retreiveData;
    setState(() {});
  }

  _pushViewIngredient(BuildContext context) async {
    final retreiveData = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddIngredientView(
                propertyTypeName: propertyType,
                selectedCatsFrom: ingredientsString)));

    ingredientsString = retreiveData;
    setState(() {});
  }

  _pushViewColor(BuildContext context) async {
    final retreiveData = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SelectColorView()));

    _recipeColor = retreiveData;
    setState(() {});
  }
}
