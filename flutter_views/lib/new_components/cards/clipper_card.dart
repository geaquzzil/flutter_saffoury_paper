// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

class SelectedClippedCard extends StatelessWidget{

}
class OnHoverCardWithListTile extends StatelessWidget {
  

  final ListTile child;

  const OnHoverCardWithListTile({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(
      builder: (isHover) {
        if (isHover) {
          return Card(
            margin: EdgeInsets.zero,
            child: child,
          );
        }
        return child;
      },
      scale: true,
      scaleDown: true,
    );
  }
}

class ClippedCard extends StatelessWidget {
  Widget child;
  Color color;
  Color? customCardColor;
  double elevation;
  bool wrapWithCardOrOutlineCard;
  BorderSideColor borderSide;
  ClippedCard(
      {super.key,
      required this.child,
      required this.color,
      this.customCardColor,
      this.wrapWithCardOrOutlineCard = true,
      this.borderSide = BorderSideColor.START,
      this.elevation = 2});

  @override
  Widget build(BuildContext context) {
    return wrapWithCardOrOutlineCard
        ? Card(
            margin: customCardColor != null
                ? const EdgeInsets.only(left: kDefaultPadding / 2)
                : null,
            shape: customCardColor != null
                ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  )
                : null,
            color: customCardColor,
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
