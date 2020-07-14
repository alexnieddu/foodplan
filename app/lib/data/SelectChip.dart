import 'package:flutter/material.dart';

class SelectChip extends StatefulWidget {
  SelectChip({Key key, this.title}) : super(key: key);

  final String title;

  SelectChipState createState() => SelectChipState();
}

class SelectChipState extends State<SelectChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text("dummy"),
    );
  }

}