import 'package:flutter/material.dart';

class OutlinedCard extends StatelessWidget {
  Widget child;
  bool fillColor;
  OutlinedCard({super.key, required this.child, this.fillColor = true});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: fillColor ? null : Theme.of(context).colorScheme.onPrimary,
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
