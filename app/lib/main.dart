import 'package:flutter/material.dart';
import 'constants.dart';
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
  List<Widget> screenStates = [PlanView(), RecipeView()];
  static int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodPlan"),
        centerTitle: true,
        elevation: 0,
      ),
      body: screenStates.elementAt(currentScreenIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.38),
            blurRadius: 15,
            offset: Offset(0, -1),
          )
        ]),
        child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), title: Text("Plan")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood), title: Text("Rezepte"))
            ],
            onTap: _setScreenState,
            currentIndex: currentScreenIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false),
      ),
    );
  }

  void _setScreenState(int tappedIndex) {
    setState(() {
      currentScreenIndex = tappedIndex;
    });
  }
}
