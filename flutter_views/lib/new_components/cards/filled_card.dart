import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  Widget child;
  Function? onPress;
  FilledCard({super.key, required this.child, this.onPress});

  @override
  Widget build(BuildContext context) {
    if (onPress == null) return getCard(context);
    return GestureDetector(
      onTap: () => onPress,
      child: getCard(context),
    );
  }

  Card getCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: child,
    );
  }
}
