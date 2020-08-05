import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';
import 'package:foodplan/model/Recipe.dart';
import 'package:path/path.dart';

List rndPix = [
  "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?ixlib=rb-1.2.1&w=1000&q=80",
  "https://i2.wp.com/harrysding.ch/wp-content/uploads/2020/03/Food-Delivery-und-Takeaway-zuerich-2-scaled.jpg?fit=2560%2C1913&ssl=1",
  "https://images.happycow.net/venues/1024/10/58/hcmp105847_838346.jpeg",
  "https://worldfoodtrip.de/wp-content/uploads/2019/06/IMG_4134-1140x620.jpg",
  "https://www.bbcgoodfood.com/sites/default/files/recipe-collections/collection-image/2013/05/chorizo-mozarella-gnocchi-bake-cropped.jpg",
  "https://x5w3j9u7.stackpathcdn.com/wp-content/uploads/2020/06/tuerkischer-bulgur-salat-rezept-kisir-680x900.jpg",
  "https://www.coolibri.de/wp-content/uploads/2019/08/toa-heftiba-MrmWoU9QDjs-unsplash-e1565696964443.jpg",
  "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/slideshows/great_food_combos_for_losing_weight_slideshow/650x350_great_food_combos_for_losing_weight_slideshow.jpg",
  "https://cdn.hellofresh.com/au/cms/pdp-slider/veggie-3.jpg"
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
              print(snapshot.data.name);
              print(snapshot.data.id);
              print(snapshot.data.imageId);
              print(snapshot.data.imagePath);
              print(snapshot.data.categories);
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
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    boxShadow: [],
                                    borderRadius: BorderRadius.circular(100)),
                                margin: EdgeInsets.only(
                                    right: 15, top: 15, bottom: 15),
                                child: ClipRRect(
                                  child: Image.network(rndPix[rndIndex],
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover),
                                  // FutureBuilder(
                                  //     future: RecipeDatabase.db
                                  //         .getImagePathOfRecipe(
                                  //             snapshot.data.first.id),
                                  //     builder: (context, imagePath) {
                                  //       if (imagePath.hasData) {
                                  //         if (imagePath.data != null) {
                                  //           return Image.file(
                                  //               File(imagePath.data.first.path),
                                  //               width: 160,
                                  //               height: 160,
                                  //               fit: BoxFit.cover);
                                  //         } else {
                                  //           return Image.network(rndPix[rndIndex],
                                  //               width: 160,
                                  //               height: 160,
                                  //               fit: BoxFit.cover);
                                  //         }
                                  //       }
                                  //     }),
                                  borderRadius: BorderRadius.circular(100),
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
                    ),
                    // Body
                    Container(
                      child: FutureBuilder(
                        future: RecipeDatabase.db
                            .getIngredientsOfRecipe(snapshot.data.id),
                        builder: (context, ingredients) {
                          if (ingredients.hasData) {
                            if (ingredients.data.length > 0) {
                              var ingredientsListString = "";
                              for (var i = 0;
                                  i < ingredients.data.length;
                                  i++) {
                                (i + 1) < ingredients.data.length
                                    ? ingredientsListString +=
                                        ingredients.data[i].name + ", "
                                    : ingredientsListString +=
                                        ingredients.data[i].name + ", ...";
                              }
                              return Text(ingredientsListString);
                            } else {
                              return Text("Bisher keine Zutaten.");
                            }
                          } else {
                            return Text(
                                "Zutatenliste konnte nicht gelesen werden.");
                          }
                        },
                      ),
                    )
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
