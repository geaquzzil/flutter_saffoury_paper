import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

// if [child] is ListTile or ExpansionListTile set The list tile background to tranparent
/// ListTile
///  collapsedBackgroundColor: Colors.transparent,
// backgroundColor: Theme.of(context).focusColor,
class FilledCard extends StatelessWidget {
  Widget child;
  Function? onPress;
  bool toScaleDown;
  FilledCard(
      {super.key, required this.child, this.onPress, this.toScaleDown = false});

  @override
  Widget build(BuildContext context) {
    if (onPress == null) return getCard(context);
    return GestureDetector(
      onTap: () => onPress,
      child: getCard(context),
    );
  }

  Widget getCard(BuildContext context) {
    //Card icon color primary
    //Icon size 24
    return OnHoverWidget(
      scaleValue: .01,
      builder: (isHovered) {
        return Card(
          shadowColor: Theme.of(context).colorScheme.shadow,
          elevation: isHovered ? 4 : 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: child,
        );
      },
      scaleDown: toScaleDown,
    );
  }
}
