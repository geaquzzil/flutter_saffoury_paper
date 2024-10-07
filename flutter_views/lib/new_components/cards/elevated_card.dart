import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

/// ListTile
///  collapsedBackgroundColor: Colors.transparent,
// backgroundColor: Theme.of(context).focusColor,
class ElevatedCard extends StatelessWidget {
  Widget child;
  final Function()? onPress;
  bool toScaleDown;
  ElevatedCard(
      {super.key, required this.child, this.onPress, this.toScaleDown = false});

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(
        scale: true,
        scaleDown: toScaleDown,
        scaleValue: .01,
        builder: (isHoverd) {
          return Card(
              shadowColor: Theme.of(context).colorScheme.shadow,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              elevation: isHoverd ? 4 : 1,
              child: onPress == null
                  ? child
                  : InkWell(onTap: () => onPress!(), child: child));
        });
  }
}
