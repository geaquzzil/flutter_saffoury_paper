import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class RoundedCornerContainer extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  const RoundedCornerContainer({super.key, this.backgroundColor, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(kBorderRadius),
        ),
      ),
      child: child,
    );
  }
}
