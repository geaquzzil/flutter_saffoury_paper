import 'package:flutter/material.dart';

class ScrollableWidget extends StatelessWidget {
  final Widget child;

  const ScrollableWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: child,
        ),
      );
}
