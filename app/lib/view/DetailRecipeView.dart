import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/Favorites.dart';
import 'package:foodplan/model/Category.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:foodplan/view/FullScreenImageView.dart';
import 'package:foodplan/widgets/TaggedBox.dart';
import 'package:google_fonts/google_fonts.dart';

const String favorit = "Favorit";

class DetailRecipeView extends StatefulWidget {
  final Recipe recipe;
  DetailRecipeView({Key key, this.recipe}) : super(key: key);
  DetailRecipeViewState createState() => DetailRecipeViewState();
}

class DetailRecipeViewState extends State<DetailRecipeView> {
  // widget.recipeId
  Color _favoriteButtonColor = Colors.grey.shade600;
  bool _isFavorite;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isFavorite = widget.recipe.isFavorite;
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
                          color: _isFavorite
                              ? _favoriteButtonColor = Colors.red
                              : _favoriteButtonColor = Colors.grey.shade600,
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
                                  ? FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: _pushFullScreenRemote,
                                      child: Hero(
                                        tag: "fullscreenImage",
                                        child: Image.network(
                                            widget.recipe.image.path,
                                            width: 160,
                                            height: 160,
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: _pushFullScreen,
                                      child: Hero(
                                        tag: "fullscreenImage",
                                        child: Image.file(
                                            File(widget.recipe.image.path),
                                            width: 160,
                                            height: 160,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
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
                  MaterialButton(
                    color: mainColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderradius)),
                    onPressed: _getRecipeImage,
                    child: Text("Rezept"),
                  ),
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
                  Container(
                    height: 33.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.recipe.ingredients.length,
                        itemBuilder: (context, i) {
                          return TaggedBox(
                              text: widget.recipe.ingredients[i].name);
                        }),
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
                  Container(
                    height: 33.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.recipe.categories.length,
                        itemBuilder: (context, i) {
                          return TaggedBox(
                              text: widget.recipe.categories[i].name);
                        }),
                  ),
                ],
              )),
        ],
      ),
    ));
  }

  void _favorite() async {
    final favs = await Favorites.getInstance();
    final favCat = Category(name: favorit);

    if (widget.recipe.isFavorite) {
      favs.removeWhere((element) => element == widget.recipe.name);
      _isFavorite = false;

      final snackBar = SnackBar(content: Text("Von Favoriten entfernt!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      favs.add(widget.recipe.name);
      _isFavorite = true;

      final snackBar = SnackBar(content: Text("Zu Favoriten hinzugefügt!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Favorites.update(favs);

    setState(() {
      _favoriteButtonColor == Colors.red
          ? _favoriteButtonColor = Colors.grey.shade600
          : _favoriteButtonColor = Colors.red;
    });
  }

  void _pushFullScreenRemote() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FullScreenImageView(
                isRemote: true, src: widget.recipe.image.path)));
  }

  void _pushFullScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FullScreenImageView(
                isRemote: false, src: widget.recipe.image.path)));
  }

  void _getRecipeImage() {
    if (widget.recipe.descriptionImage.isRemote) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullScreenImageView(
                  isRemote: widget.recipe.descriptionImage.isRemote,
                  src: widget.recipe.descriptionImage.path)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullScreenImageView(
                  isRemote: widget.recipe.descriptionImage.isRemote,
                  src: widget.recipe.descriptionImage.path)));
    }
  }
}
