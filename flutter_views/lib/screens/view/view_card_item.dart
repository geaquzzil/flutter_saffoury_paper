import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ViewCardItem extends StatelessWidget {
  String title;
  String description;
  IconData icon;
  ViewAbstract? object;
  ViewCardItem(
      {Key? key,
      this.object,
      required this.title,
      required this.description,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => object?.onCardClickedView(context),
      onLongPress: () => object?.onCardLongClickedView(context),
      title: (object?.getMainLabelText(context) ?? Text(title)),
      subtitle: (object?.getMainHeaderText(context) ?? Text(description)),
      leading: object != null
          ? Hero(tag: object!, child: Icon(object?.getMainIconData()))
          : Icon(icon),
      trailing: object != null
          ? InkWell(
              onTap: () => object?.onCardTrailingClickedView(context),
              child: const Icon(Icons.arrow_forward_ios))
          : null,
    );
  }
}
