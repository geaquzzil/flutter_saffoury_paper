import 'package:flutter/material.dart';

class SliverAnimatedCard extends StatelessWidget {
  final Widget child;

  final Animation<double> animation;

  const SliverAnimatedCard(
      {super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(sizeFactor: animation, child: child);
  }
}
