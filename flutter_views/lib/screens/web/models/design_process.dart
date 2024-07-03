import 'package:flutter/material.dart';

class DesignProcess {
  final String title;
  final String? imagePath;
  final String? imageUrl;
  final IconData? iconData;
  final String subtitle;

  DesignProcess({
    required this.title,
    this.imagePath,
    this.imageUrl,
    this.iconData,
    required this.subtitle,
  }) : assert(imagePath != null || iconData != null);

  Widget getImage() {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: 40.0,
      );
    } else {
      return Icon(
        iconData!,
        size: 40,
        color: Colors.white,
      );
    }
  }
}
