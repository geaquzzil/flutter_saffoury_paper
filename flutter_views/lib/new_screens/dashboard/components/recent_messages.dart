import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class RecentMessages extends StatelessWidget {
  const RecentMessages({
    required this.onPressedMore,
    super.key,
  });

  final Function() onPressedMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(EvaIcons.messageCircle, color: Theme.of(context).primaryColor),
        const SizedBox(width: 10),
        Text(
          "Recent Messages",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressedMore,
          icon: const Icon(EvaIcons.moreVertical),
          tooltip: "more",
        )
      ],
    );
  }
}
