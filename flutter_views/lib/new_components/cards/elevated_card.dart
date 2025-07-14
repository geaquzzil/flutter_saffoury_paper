import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

/// ListTile
///  collapsedBackgroundColor: Colors.transparent,
// backgroundColor: Theme.of(context).focusColor,
@Deprecated("Use Cards")
class ElevatedCard extends StatelessWidget {
  Widget child;
  final Function()? onPress;
  bool enableScaling;
  bool toScaleDown;
  ElevatedCard(
      {super.key,
      required this.child,
      this.onPress,
      this.toScaleDown = false,
      this.enableScaling = false});

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(
        scale: true,
        scaleDown: toScaleDown,
        scaleValue: .01,
        builder: (isHoverd) {
          return Text("TODODODODO");
        });
  }
}
