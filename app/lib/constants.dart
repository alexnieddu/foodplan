import 'package:flutter/material.dart';

const Color mainColor = Color(0xFF009688);
MaterialColor myColor = MaterialColor(0xff5ae7d9, color);
Map<int, Color> color = {
  50: Color.fromRGBO(90, 231, 217, .1),
  100: Color.fromRGBO(90, 231, 217, .2),
  200: Color.fromRGBO(90, 231, 217, .3),
  300: Color.fromRGBO(90, 231, 217, .4),
  400: Color.fromRGBO(90, 231, 217, .5),
  500: Color.fromRGBO(90, 231, 217, .6),
  600: Color.fromRGBO(90, 231, 217, .7),
  700: Color.fromRGBO(90, 231, 217, .8),
  800: Color.fromRGBO(90, 231, 217, .9),
  900: Color.fromRGBO(90, 231, 217, 1),
};
BoxShadow constShadow = BoxShadow(
  color: mainColor.withOpacity(0.38),
  blurRadius: 10,
  offset: Offset(0, -1),
);
BoxShadow constShadowDark = BoxShadow(
  color: Colors.black.withOpacity(.2),
  blurRadius: 10,
  offset: Offset(0, 0),
);
BoxShadow constShadowDarkLight = BoxShadow(
  color: Colors.black.withOpacity(.05),
  blurRadius: 10,
  offset: Offset(0, 0),
);
const double borderradius = 15.0;

const int colorOffset = 30000;

List rndColors = [];