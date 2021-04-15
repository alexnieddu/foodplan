import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/widgets/TaggedBox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

List rndPix = [
  "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?ixlib=rb-1.2.1&w=1000&q=80"
];

class DetailRecipeView extends StatefulWidget {
  final Recipe recipe;
  DetailRecipeView({Key key, this.recipe}) : super(key: key);
  DetailRecipeViewState createState() => DetailRecipeViewState();
}

class DetailRecipeViewState extends State<DetailRecipeView> {
  // widget.recipeId
  bool isFavorite = false;
  Color _favoriteButtonColor = Colors.grey.shade600;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(70)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(widget.recipe.backgroundColor).withOpacity(.4),
                        Color(widget.recipe.backgroundColor + colorOffset)
                            .withOpacity(.4)
                      ]),
                  // color: Color(widget.recipe.backgroundColor)
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
                          icon: Icon(Icons.favorite),
                          color: _favoriteButtonColor,
                          onPressed: _favorite),
                      IconButton(icon: Icon(Icons.more_vert), onPressed: null)
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
                                borderRadius: BorderRadius.circular(100)),
                            margin:
                                EdgeInsets.only(right: 15, top: 0, bottom: 15),
                            child: ClipRRect(
                              child: widget.recipe.image.isRemote
                                  ? Image.network(widget.recipe.image.path,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover)
                                  : Image.file(File(widget.recipe.image.path),
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(100),
                            )),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: widget.recipe.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily:
                                      GoogleFonts.pacifico().fontFamily)),
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
                        text: "Bemerkung",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: GoogleFonts.pacifico().fontFamily)),
                  ),
                  SizedBox(height: 15),
                  widget.recipe.description != null
                      ? Text(widget.recipe.description)
                      : Text(""),
                  SizedBox(height: 20),
                  // Ingredients
                  RichText(
                    text: TextSpan(
                        text: "Zutaten",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: GoogleFonts.pacifico().fontFamily)),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      for (var i = 0; i < widget.recipe.ingredients.length; i++)
                        TaggedBox(text: widget.recipe.ingredients[i].name)
                    ],
                  ),
                  SizedBox(height: 20),
                  // Categories
                  RichText(
                    text: TextSpan(
                        text: "Kategorien",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: GoogleFonts.pacifico().fontFamily)),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      for (var i = 0; i < widget.recipe.categories.length; i++)
                        TaggedBox(text: widget.recipe.categories[i].name)
                    ],
                  ),
                ],
              )),
        ],
      ),
    ));
  }

  void _favorite() {
    setState(() {
      _favoriteButtonColor == Colors.red
          ? _favoriteButtonColor = Colors.grey.shade600
          : _favoriteButtonColor = Colors.red;
    });
  }
}
