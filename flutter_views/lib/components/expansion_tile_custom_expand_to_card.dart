import 'package:flutter/material.dart';

class ExpansionTileCard extends ExpansionTile {
  ExpansionTileCard({
    required BuildContext context,
    super.key,
    required super.title,
    super.leading,
    super.subtitle,
    super.onExpansionChanged,
    super.children = const <Widget>[],
    super.trailing,
    super.initiallyExpanded = false,
    super.maintainState = false,
    super.tilePadding,
    super.expandedCrossAxisAlignment,
    super.expandedAlignment,
    super.childrenPadding,
    super.collapsedBackgroundColor,
    super.textColor,
    super.collapsedTextColor,
    super.iconColor,
    super.collapsedIconColor,
    super.collapsedShape,
    super.clipBehavior,
    super.controlAffinity,
    super.controller,
    super.dense,
    super.visualDensity,
    super.minTileHeight,
    super.enableFeedback = true,
    super.enabled = true,
    super.expansionAnimationStyle,
  }) : super(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: ElevationOverlay.overlayColor(context, 2));
}
