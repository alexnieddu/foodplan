import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatelessWidget {
  final String src;
  final bool isRemote;
  final heroTag = "fullscreenImage";

  FullScreenImageView({this.src, this.isRemote});

  @override
  Widget build(BuildContext context) {
    if (isRemote) {
      return Hero(
          tag: heroTag, child: PhotoView(imageProvider: NetworkImage(src)));
    } else {
      return Hero(
          tag: heroTag, child: PhotoView(imageProvider: FileImage(File(src))));
    }
  }
}
