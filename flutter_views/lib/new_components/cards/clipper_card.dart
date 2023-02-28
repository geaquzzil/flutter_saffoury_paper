import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';

class ClippedCard extends StatelessWidget {
  Widget child;
  Color color;
  double elevation;
  bool wrapWithCardOrOutlineCard;
  BorderSideColor borderSide;
  ClippedCard(
      {super.key,
      required this.child,
      required this.color,
      this.wrapWithCardOrOutlineCard = true,
      this.borderSide = BorderSideColor.START,
      this.elevation = 2});

  @override
  Widget build(BuildContext context) {
    return wrapWithCardOrOutlineCard
        ? Card(
            elevation: elevation,
            child: getCardChild(),
          )
        : OutlinedCard(fillColor: false, child: getCardChild());
  }

  ClipPath getCardChild() {
    return ClipPath(
      
      clipper: ShapeBorderClipper(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: AnimatedContainer(
        // duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border(
          top: borderSide == BorderSideColor.TOP
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
          bottom: borderSide == BorderSideColor.BOTTOM
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
          left: borderSide == BorderSideColor.START
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
          right: borderSide == BorderSideColor.END
              ? BorderSide(color: color, width: 5)
              : BorderSide.none,
        )),
        duration: const Duration(milliseconds: 275),
        child: child,
      ),
    );
  }
}

enum BorderSideColor { TOP, BOTTOM, START, END }
