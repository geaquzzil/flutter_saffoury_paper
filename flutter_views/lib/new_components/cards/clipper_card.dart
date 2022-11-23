import 'package:flutter/material.dart';

class ClippedCard extends StatelessWidget {
  Widget child;
  Color color;
  double elevation;
  BorderSideColor borderSide;
  ClippedCard(
      {super.key,
      required this.child,
      required this.color,
      this.borderSide = BorderSideColor.START,
      this.elevation = 2});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
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
          child: child,
        ),
      ),
    );
  }
}

enum BorderSideColor { TOP, BOTTOM, START, END }
