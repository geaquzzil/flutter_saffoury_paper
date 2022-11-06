import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  Widget child;
  FilledCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: child,
    );
  }
}
