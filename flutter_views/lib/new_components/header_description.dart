import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class HeaderDescription extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? iconData;
  final bool isTitleLarge;
  final Color? titleColor;
  final Widget? trailing;
  final bool isSliver;
  final bool setDivider;
  const HeaderDescription({
    super.key,
    required this.title,
    this.description,
    this.iconData,
    this.trailing,
    this.titleColor,
    this.setDivider = false,
    this.isSliver = false,
    this.isTitleLarge = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget text = Text(
      title,
      style: !isTitleLarge
          ? null
          : Theme.of(context).textTheme.titleLarge?.copyWith(color: titleColor),
    );
    if (setDivider) {
      text = Row(
        children: [
          text,
          Expanded(child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Divider(),
          )),
        ],
      );
    }
    Widget listTile = ListTile(
      trailing: trailing,
      leading: iconData == null ? null : Icon(iconData),
      title: text,
      subtitle: description == null ? null : Text(description!),
    );
    if (!isSliver) {
      return listTile;
    } else {
      return SliverToBoxAdapter(child: listTile);
    }
  }
}
