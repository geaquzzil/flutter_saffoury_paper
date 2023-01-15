import 'package:flutter/material.dart';

class HeaderDescriptionAsExpanstion extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? iconData;
  final bool isTitleLarge;
  final Color? titleColor;
  final Widget? trailing;
  final List<Widget>? children;
  const HeaderDescriptionAsExpanstion(
      {super.key,
      required this.title,
      this.description,
      this.iconData,
      this.trailing,
      this.titleColor,
      this.children,
      this.isTitleLarge = true});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: trailing,
      leading: iconData == null ? null : Icon(iconData),
      title: Text(
        title,
        style: !isTitleLarge
            ? null
            : Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: titleColor),
      ),
      subtitle: description == null ? null : Text(description!),
      children: children ?? [],
    );
  }
}
