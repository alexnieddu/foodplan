import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FancyText extends StatelessWidget {
  final String fancyText;

  FancyText(this.fancyText);

  @override
  Widget build(BuildContext context) {
    return Text(fancyText,
        style: TextStyle(fontFamily: GoogleFonts.pacifico().fontFamily));
  }
}
