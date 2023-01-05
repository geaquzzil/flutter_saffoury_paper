import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class OutlinedCard extends StatelessWidget {
  Widget child;
  bool fillColor;
  PaletteGenerator? color;
  final Function()? onPress;
  OutlinedCard(
      {super.key,
      required this.child,
      this.color,
      this.fillColor = true,
      this.onPress});

  @override
  Widget build(BuildContext context) {
    if (onPress == null) return getCard(context);
    return Card(
        color: fillColor ? null : Theme.of(context).colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color != null
                ? color!.darkVibrantColor!.color
                : Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(onTap: () => onPress!(), child: child));
  }

  Card getCard(BuildContext context) {
    return Card(
        color: fillColor ? null : Theme.of(context).colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: child);
  }
}
