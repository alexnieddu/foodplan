import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final String src;
  final bool isRemote;
  final heroTag = "fullscreenImage";

  FullScreenImageView({this.src, this.isRemote});

  @override
  Widget build(BuildContext context) {
    if (isRemote) {
      return Hero(tag: heroTag, child: Image.network(src));
    } else {
      return Hero(tag: heroTag, child: Image.file(File(src)));
    }
  }
}
