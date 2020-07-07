import 'package:flutter/material.dart';
import 'package:foodplan/view/RecipeView.dart';
import 'package:foodplan/view/PlanView.dart';

final String appName = "FoodPlan";

void main() => runApp(FoodPlan());

class FoodPlan extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
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
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            indicatorWeight: 4.0,
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
