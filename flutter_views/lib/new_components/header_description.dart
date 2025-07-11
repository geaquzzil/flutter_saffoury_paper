import 'package:flutter/material.dart';

class HeaderDescription extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? iconData;
  final bool isTitleLarge;
  final Color? titleColor;
  final Widget? trailing;
  final bool isSliver;
  const HeaderDescription(
      {super.key,
      required this.title,
      this.description,
      this.iconData,
      this.trailing,
      this.titleColor,
      this.isSliver = false,
      this.isTitleLarge = true});

  @override
  Widget build(BuildContext context) {
    Widget listTile = ListTile(
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
    );
    if (!isSliver) {
      return listTile;
    } else {
      return SliverToBoxAdapter(
        child: listTile,
      );
    }
  }
}
