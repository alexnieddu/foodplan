import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/widgets/FancyText.dart';

const String categoryString = "Zutaten";

class AddIngredientView extends StatefulWidget {
  final String propertyTypeName;
  final List<String> selectedCatsFrom;
  AddIngredientView({Key key, this.propertyTypeName, this.selectedCatsFrom})
      : super(key: key);
  AddIngredientViewState createState() => AddIngredientViewState();
}

class AddIngredientViewState extends State<AddIngredientView> {
  final propertyNameController = TextEditingController();
  List<String> selectedCats;

  @override
  Widget build(BuildContext context) {
    selectedCats = widget.selectedCatsFrom != null
        ? widget.selectedCatsFrom
        : selectedCats;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: FancyText("${widget.propertyTypeName}"),
            iconTheme: IconThemeData(color: mainColor),
          ),
          body: Column(
            children: [
              // Text(selectedCats.toString()),
              FutureBuilder(
                  future: RecipeDatabase.db.getAllIngredients(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length + 1,
                            itemBuilder: (context, i) {
                              if (i == 0) {
                                return ListTile(
                                    trailing:
                                        Text(selectedCats.length.toString()),
                                    leading: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: _addCategory),
                                    title: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Zutatenname",
                                      ),
                                      controller: propertyNameController,
                                    ));
                              } else {
                                i--;
                                Ingredient cat = snapshot.data[i];
                                return CheckboxListTile(
                                    value: selectedCats.contains(cat.name),
                                    onChanged: (bool selected) {
                                      if (selected) {
                                        selectedCats.add(cat.name);
                                      } else {
                                        selectedCats.remove(cat.name);
                                      }
                                      setState(() {});
                                    },
                                    title: Text(cat.name));
                              }
                            }),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              // IconButton(icon: Icon(Icons.save), onPressed: _saveSelection)
            ],
          )),
    );
  }

  void _saveSelection() {
    final msg = "Wähle Kategorien aus!";
    if (selectedCats.isNotEmpty) {
      // if (widget.propertyTypeName == categoryString) {
      //   Category newCat = Category(name: propertyNameController.text);
      //   RecipeDatabase.db.createCategory(newCat);
      // } else {
      //   Ingredient newIng = Ingredient(name: propertyNameController.text);
      //   RecipeDatabase.db.createIngredient(newIng);
      // }
      Navigator.pop(context, selectedCats);
    } else {
      final snackBar = SnackBar(content: Text(msg));

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _addCategory() {
    final msg = "Gib eine Kategorie ein!";
    final success = "'${propertyNameController.text}' wurde angelegt!";
    if (propertyNameController.text.isNotEmpty) {
      if (widget.propertyTypeName == categoryString) {
        Category newCat = Category(name: propertyNameController.text);
        RecipeDatabase.db.createCategory(newCat);
      } else {
        Ingredient newIng = Ingredient(name: propertyNameController.text);
        RecipeDatabase.db.createIngredient(newIng);
      }

      setState(() {});

      final snackBar = SnackBar(content: Text(success));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      propertyNameController.text = "";
    } else {
      final snackBar = SnackBar(content: Text(msg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> _onBackPressed() {
    _saveSelection();
    // Navigator.pop(context, widget.selectedCatsFrom);
    // return Future.value(false);
  }
}
