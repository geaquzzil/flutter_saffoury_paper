import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

class Cards extends StatelessWidget {
  final CardType type;
  final Function(bool isHovered) child;
  final Function()? onPress;
  final bool toScaleDown;
  final bool enableScaling;
  const Cards({
    super.key,
    required this.type,
    required this.child,
    this.onPress,
    this.toScaleDown = false,
    this.enableScaling = false,
  });

  @override
  Widget build(BuildContext context) {
    if (enableScaling == false) {
      return _getCard(context, child.call(false));
    }
    return OnHoverWidget(
        scale: true,
        scaleDown: toScaleDown,
        scaleValue: .02,
        builder: (isHoverd) {
          return _getCard(context, child.call(isHoverd));
        });
  }

  Widget _getCard(BuildContext context, Widget child) {
    switch (type) {
      case CardType.normal:
        return getElevatedCard(context, child,
            isHoverd: false, onPress: onPress);
      case CardType.filled:
        return getFilledCard(context, child, isHoverd: false, onPress: onPress);
      case CardType.filled_outline:
        return getFilledCardWithOutline(context, child,
            isHoverd: false, onPress: onPress);
      case CardType.outline:
        return getOutlineCard(context, child,
            isHoverd: false, onPress: onPress);
    }
  }
}

enum CardType { normal, filled, outline, filled_outline }
