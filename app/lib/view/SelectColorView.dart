import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';
import 'package:foodplan/widgets/FancyText.dart';

class ColorPalette {
  int value;
  String name;

  ColorPalette({this.value, this.name});
}

class SelectColorView extends StatefulWidget {
  SelectColorView({Key key}) : super(key: key);
  SelectColorViewState createState() => SelectColorViewState();
}

class SelectColorViewState extends State<SelectColorView> {
  final red = ColorPalette(value: 0xFFFF0000, name: "rot");
  final green = ColorPalette(value: 0xFF00FF00, name: "grün");
  final blue = ColorPalette(value: 0xFF0000FF, name: "blau");
  final yellow = ColorPalette(value: 0xFFFFFF00, name: "gelb");
  final violet = ColorPalette(value: 0xFFFF00FF, name: "lila");
  final defaultColor = ColorPalette(value: -1, name: "zufällig");
  int _recipeColor = -1;

  @override
  Widget build(BuildContext context) {
    List<ColorPalette> colorPalette = [
      defaultColor,
      red,
      green,
      blue,
      yellow,
      violet
    ];
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: FancyText("Farbe"),
          iconTheme: IconThemeData(color: mainColor),
        ),
        body: ListView.builder(
          itemCount: colorPalette.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(colorPalette[i].name),
              leading: Radio(
                value: colorPalette[i].value,
                groupValue: _recipeColor,
                onChanged: (int value) {
                  setState(() {
                    _recipeColor = value;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(context, _recipeColor);
    return Future.value(false);
  }
}
