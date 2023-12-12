import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class OutlinedCard extends StatelessWidget {
  Widget child;
  bool fillColor;
  PaletteGenerator? color;
  final Function()? onPress;
  final double reduce;
  OutlinedCard(
      {super.key,
      required this.child,
      this.reduce = 20,
      this.color,
      this.fillColor = true,
      this.onPress});

  @override
  Widget build(BuildContext context) {
    if (onPress == null) return getCard(context);
    return Card(
        color: fillColor ? null : Theme.of(context).colorScheme.surface,
        // margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color != null
                ? color!.darkMutedColor?.color ??
                    Theme.of(context).colorScheme.outline.withOpacity(.8)
                : Theme.of(context).colorScheme.outline.withOpacity(.8),
          ),
          borderRadius: BorderRadius.all(Radius.circular(reduce)),
        ),
        child: InkWell(onTap: () => onPress!(), child: child));
  }

  Card getCard(BuildContext context) {
    return Card(
        color: fillColor ? null : Theme.of(context).colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color != null
                ? color!.darkMutedColor?.color ??
                    Theme.of(context).colorScheme.outline.withOpacity(.8)
                : Theme.of(context).colorScheme.outline.withOpacity(.8),
          ),
          borderRadius: BorderRadius.all(Radius.circular(reduce)),
        ),
        child: child);
  }
}
