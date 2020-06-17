import 'package:flutter/material.dart';
import 'model/recipe.dart';

final String appName = "FoodPlan";

void main() {
  runApp(FoodPlan());
}

class FoodPlan extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _callMore() {
    print("More was called.");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Plan",
              ),
              Tab(text: "Recipes"),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
          title: Text(appName),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onPressed: _callMore),
          ],
        ),
        body: TabBarView(
          children: [
            PlanView(),
            RecipeView(),
          ],
        ),
      ),
    );
  }
}

class PlanView extends StatefulWidget {
  PlanViewState createState() => PlanViewState();
}

class PlanViewState extends State<PlanView> {
  List<Recipe> recipes = [
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
    Recipe("Pizza", ["Mehl", "Wasser", "Hefe", "Käse", "Tomaten"], ["FastFood", "Italy"], "https://img.chefkoch-cdn.de/rezepte/1002961205505361/bilder/1051045/crop-960x720/pizza-margherita-nach-italienischer-art.jpg"),
    Recipe("Bolognese", ["Hackfleisch", "Tomaten", "Zwiebeln"], ["Italy", "Fleisch"], "https://www.kuechengoetter.de/uploads/media/960x960/02/36362-spaghetti-bolognese.jpg?v=2-17"),
    Recipe("Rotes Curry", ["Kokosmilch", "Rote Currypaste", "Reis", "Hühnchen"], ["Scharf", "Östlich", "Fleisch"], "https://cdn.asiastreetfood.com/wp-content/uploads/2015/03/Rotes-Thai-Curry-Rezept.jpg?strip=all&lossy=1&quality=80&fit=1920%2C1280&ssl=1"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, i) {
          var recipe = recipes[i];
          return ListTile(
            title: Text(recipe.name),
            subtitle: Row(
              children: <Widget>[
                for(var cat in recipe.categories) Text("$cat ")
              ],
            ),
            leading: Container(
              child: Image.network(recipe.imageURL, fit: BoxFit.cover,),
              width: 50,
              height: 50,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(shape: BoxShape.circle,),
              clipBehavior: Clip.hardEdge,
            ),
            trailing: Icon(Icons.refresh),
            onLongPress: () {
              print("Long pressed on item ${recipe.name}");
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("FAB was pressed.");
          },
          child: Icon(Icons.refresh)),
    );
  }
}

class RecipeView extends StatefulWidget {
  RecipeViewState createState() => RecipeViewState();
}

class RecipeViewState extends State<RecipeView> {
  int numberOfRecipesInPlan = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: numberOfRecipesInPlan,
        itemBuilder: (context, i) {
          return ListTile(
            title:
                Text("Bolognese"),
            subtitle: Text("Fleisch"),
            onLongPress: () {
              print("Long pressed on item Bolognese");
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("FAB was pressed.");
          },
          child: Icon(Icons.add)),
    );
  }
}
