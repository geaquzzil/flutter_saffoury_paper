import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
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
          child: Icon(icon),
        ));
  }
}
