import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

/// ListTile
///  collapsedBackgroundColor: Colors.transparent,
// backgroundColor: Theme.of(context).focusColor,
@Deprecated("Use Cards")
class CardNormal extends StatelessWidget {
  Widget Function(bool isHovered) child;
  bool toScaleDown;
  CardNormal({
    super.key,
    required this.child,
    this.toScaleDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(
        scale: true,
        scaleDown: toScaleDown,
        scaleValue: .02,
        builder: (isHoverd) {
          return Card(
              shadowColor: Colors.transparent,
              color: Colors.transparent,
              elevation: isHoverd ? 4 : 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
              ),
              child: child.call(isHoverd));
        });
  }
}
