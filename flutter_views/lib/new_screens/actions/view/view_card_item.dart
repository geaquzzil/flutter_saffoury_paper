import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';

class ViewCardItem extends StatelessWidget {
  String title;
  String description;
  IconData icon;
  ViewAbstract? object;
  ValueNotifier<ViewAbstract>? valueNotifier;
  ValueNotifier<SecondPaneHelper?>? secNotifier;
  bool overrideTrailingToNull;
  ViewCardItem(
      {super.key,
      this.object,
      required this.title,
      required this.description,
      this.valueNotifier,
      this.secNotifier,
      this.overrideTrailingToNull = false,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (secNotifier != null) {
          secNotifier?.value = SecondPaneHelper(
              title: object!.getMainHeaderLabelTextOnly(context),
              value: object);
        } else {
          object?.onCardClickedView(context, isSecoundSubPaneView: true);
        }
      },
      onLongPress: () => object?.onCardLongClickedView(context),
      title: getTextTitle(
          context, object?.getMainHeaderLabelTextOnly(context) ?? title),
      subtitle: getTextSubTitle(
          context, object?.getMainHeaderTextOnly(context) ?? description),
      leading: object != null
          ? Hero(tag: object!, child: Icon(object?.getMainIconData()))
          : Icon(icon),
      trailing: overrideTrailingToNull
          ? null
          : object != null
              ? InkWell(
                  onTap: () => object?.onCardTrailingClickedView(context),
                  child: const Icon(Icons.arrow_forward_ios))
              : null,
    );
  }

  Text getTextTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }

  Text getTextSubTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.bodyMedium);
  }
}
