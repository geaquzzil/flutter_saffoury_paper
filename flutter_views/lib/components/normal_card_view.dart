import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class NormalCardView extends StatelessWidget {
  String title;
  String description;
  IconData icon;
  ViewAbstract? object;
  NormalCardView(
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
      title: (object?.getLabelText(context) ?? Text(title)),
      subtitle: (object?.getHeaderText(context) ?? Text(description)),
      leading: Icon(object?.getIconData(context) ?? icon),
      trailing: object != null
          ? InkWell(
              onTap: () => object?.onCardTrailingClickedView(context),
              child: const Icon(Icons.arrow_forward_ios))
          : null,
    );
  }
}
