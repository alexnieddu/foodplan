import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:foodplan/view/RecipeView.dart';
import 'package:foodplan/view/PlanView.dart';
import 'package:google_fonts/google_fonts.dart';

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
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.teal)),
        appBarTheme:
            AppBarTheme(color: Colors.white.withOpacity(0), elevation: 0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> screenStates = [PlanView(), RecipeView()];
  static int currentScreenIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Foodplan", style: GoogleFonts.pacifico()),
        centerTitle: true,
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
                  icon: Icon(Icons.calendar_today), label: "Plan"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood), label: "Rezepte")
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
