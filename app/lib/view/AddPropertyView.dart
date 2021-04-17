import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Ingredient.dart';
import 'package:foodplan/widgets/FancyText.dart';

const String categoryString = "Kategorie";

class AddPropertyView extends StatefulWidget {
  final String propertyTypeName;
  final List<String> selectedCats;
  AddPropertyView({Key key, this.propertyTypeName, this.selectedCats}) : super(key: key);
  AddPropertyViewState createState() => AddPropertyViewState();
}

class AddPropertyViewState extends State<AddPropertyView> {
  final propertyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FancyText("${widget.propertyTypeName}"),
          iconTheme: IconThemeData(color: mainColor),
        ),
        body: Column(
          children: [
            Text(widget.selectedCats.toString()),
            FutureBuilder(
                future: RecipeDatabase.db.getAllCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            Category cat = snapshot.data[i];
                            return CheckboxListTile(
                                value: widget.selectedCats.contains(cat.name),
                                onChanged: (bool selected) {
                                  if (selected) {
                                    widget.selectedCats.add(cat.name);
                                    setState(() {});
                                  } else {
                                    widget.selectedCats.remove(cat.name);
                                    setState(() {});
                                  }
                                },
                                title: Text(cat.name));
                          }),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            IconButton(icon: Icon(Icons.save), onPressed: _addProperty)
          ],
        ));
  }

  void _addProperty() {
    if (widget.selectedCats.isNotEmpty) {
      // if (widget.propertyTypeName == categoryString) {
      //   Category newCat = Category(name: propertyNameController.text);
      //   RecipeDatabase.db.createCategory(newCat);
      // } else {
      //   Ingredient newIng = Ingredient(name: propertyNameController.text);
      //   RecipeDatabase.db.createIngredient(newIng);
      // }
      Navigator.pop(context, widget.selectedCats);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Feld ist leer."),

      // final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

      // // Find the ScaffoldMessenger in the widget tree
      // // and use it to show a SnackBar.
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      ));
    }
  }
}
