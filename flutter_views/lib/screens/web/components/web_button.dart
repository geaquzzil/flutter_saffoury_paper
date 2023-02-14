import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class WebButton extends StatelessWidget {
  final String title;
  final bool primary;
  final void Function()? onPressed;
  const WebButton(
      {super.key, this.primary = true, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 48.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 28.0,
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: kPrimaryColor,
          ),
        ),
        height: 48.0,
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: TextButton(
          onPressed: onPressed,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
