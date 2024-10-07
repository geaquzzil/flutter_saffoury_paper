import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:palette_generator/palette_generator.dart';

/// ListTile
///  collapsedBackgroundColor: Colors.transparent,
// backgroundColor: Theme.of(context).focusColor,
class OutlinedCard extends StatelessWidget {
  Widget child;
  bool fillColor;
  PaletteGenerator? color;
  final Function()? onPress;
  final double reduce;
  bool toScaleDown;
  OutlinedCard(
      {super.key,
      required this.child,
      this.reduce = 20,
      this.color,
      this.fillColor = true,
      this.toScaleDown = true,
      this.onPress});

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(
        scaleValue: .01,
        builder: (isHoverd) {
          return Card(
              shadowColor: Theme.of(context).colorScheme.shadow,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              color: fillColor ? null : Theme.of(context).colorScheme.surface,
              elevation: isHoverd ? 4 : 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: color != null
                      ? color!.darkMutedColor?.color ??
                          Theme.of(context).colorScheme.outlineVariant
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius:
                    const BorderRadius.all(Radius.circular(kBorderRadius)),
              ),
              child: onPress == null
                  ? child
                  : InkWell(onTap: () => onPress!(), child: child));
        });
  }
}
