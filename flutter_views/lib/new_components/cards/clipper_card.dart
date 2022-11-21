import 'package:flutter/material.dart';

class ClippedCard extends StatelessWidget {
  Widget child;
  Color color;
  ClippedCard({super.key, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: color, width: 5))),
          child: child,
        ),
      ),
    );
  }
}
