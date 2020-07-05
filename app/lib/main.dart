import 'package:flutter/material.dart';
import 'model/recipe.dart';

final String appName = "FoodPlan";
RecipeProvider provider;

void main() {
  provider.open("foodplan");
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
  List<Recipe> recipes = [Recipe.recipe("Pizza")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, i) {
          var recipe = recipes[i];
          return ListTile(
            title: Text(recipe.name),
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

  Recipe testRecipe = Recipe.recipe("Test-Bolognese");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text("{snapshot.data[i].name}"),
                subtitle: Text("Fleisch"),
                onLongPress: () {
                  print("Long pressed on item Bolognese");
                },
              );
            },
          );
        },
        future: provider.getAllRecipe(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            provider.insert(testRecipe);
          },
          child: Icon(Icons.add)),
    );
  }
}
