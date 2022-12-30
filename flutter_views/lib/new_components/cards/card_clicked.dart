import 'package:flutter/material.dart';

class CardClicked extends StatelessWidget {
  Widget child;
  final Function? onPress;
  CardClicked({super.key, required this.child, this.onPress});

  @override
  Widget build(BuildContext context) {
    if (onPress == null) return getCard(context);
    return Card(
        child: InkWell(
      onTap: () => onPress!(),
      child: Ink(child: getCard(context)),
    ));
  }

  Card getCard(BuildContext context) {
    return Card(child: child);
  }
}
