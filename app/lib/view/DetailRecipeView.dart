import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/data/RecipeDatabase.dart';

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
  DetailRecipeView({Key key, int this.recipeId}) : super(key: key);
  DetailRecipeViewState createState() => DetailRecipeViewState();
}

class DetailRecipeViewState extends State<DetailRecipeView> {
  // widget.recipeId
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: RecipeDatabase.db.getRecipe(widget.recipeId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(70)),
                          // gradient: LinearGradient(
                          //     begin: Alignment.topLeft,
                          //     end: Alignment.bottomRight,
                          //     colors: [
                          //       Color(snapshot.data.first.backgroundColor)
                          //           .withOpacity(.3),
                          //       Color(snapshot.data.first.backgroundColor)
                          //           .withOpacity(.9)
                          //     ]),
                          color: Color(snapshot.data.first.backgroundColor)
                              .withOpacity(.4),
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
                                  child: Image.network(
                                      rndPix[Random().nextInt(rndPix.length)],
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(100),
                                )),
                            RichText(
                              text: TextSpan(
                                  text: snapshot.data.first.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 25,
                                  )),
                            ),
                          ],
                        ),
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
