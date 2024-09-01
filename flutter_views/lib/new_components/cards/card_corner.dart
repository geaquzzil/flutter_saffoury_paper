import 'package:flutter/material.dart';

class CardCorner extends Card {
  final double cornerRedius;
  CardCorner(
      {super.key,
      super.borderOnForeground,
      double? margin,
      super.child,
      super.clipBehavior,
      super.color,
      super.elevation,
      super.semanticContainer,
      super.shadowColor,
      super.surfaceTintColor,
      this.cornerRedius = 80})
      : super(
        
            margin: EdgeInsets.all(margin ?? 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(cornerRedius)),
            ));
}
