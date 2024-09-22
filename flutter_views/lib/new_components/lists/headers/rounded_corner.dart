import 'package:flutter/material.dart';

class RoundedCornerContainer extends StatelessWidget {
  Color? backgroundColor;
  Widget child;

  RoundedCornerContainer({this.backgroundColor, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: child,
    );
  }
}
