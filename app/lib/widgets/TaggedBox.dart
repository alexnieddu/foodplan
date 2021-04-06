import 'package:flutter/material.dart';
import 'package:foodplan/constants.dart';

class TaggedBox extends StatefulWidget {
  final String text;
  TaggedBox({Key key, this.text}) : super(key: key);
  TaggedBoxState createState() => TaggedBoxState();
}

class TaggedBoxState extends State<TaggedBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Container(
        child: Text(widget.text),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderradius),
            boxShadow: [constShadowDarkLight],
            color: Colors.white),
      ),
    );
  }
}
