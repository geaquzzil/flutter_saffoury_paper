

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class TeamMember extends StatelessWidget {
  const TeamMember({
    required this.totalMember,
    required this.onPressedAdd,
    super.key,
  });

  final int totalMember;
  final Function() onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kFontColorPallets[0],
            ),
            children: [
              const TextSpan(text: "Team Member "),
              TextSpan(
                text: "($totalMember)",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kFontColorPallets[2],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressedAdd,
          icon: const Icon(EvaIcons.plus),
          tooltip: "add member",
        )
      ],
    );
  }
}
