import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class RoundedIconButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;
  final double size;
  const RoundedIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
        ));
  }
}
