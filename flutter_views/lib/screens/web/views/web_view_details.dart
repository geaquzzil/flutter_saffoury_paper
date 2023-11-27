import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';

class WebViewDetails extends StatelessWidget {
  ViewAbstract viewAbstract;
  WebViewDetails({Key? key, required this.viewAbstract}) : super(key: key);
  Widget buildItem(BuildContext context, String field) {
    debugPrint("MasterView buildItem $field");
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    if (fieldValue == null) {
      return ViewCardItem(title: field, description: "null", icon: Icons.abc);
    } else if (fieldValue is ViewAbstract) {
      return ViewCardItem(
          title: "", description: "", icon: Icons.abc, object: fieldValue);
    } else if (fieldValue is ViewAbstractEnum) {
      return ViewCardItem(
          title: fieldValue.getMainLabelText(context),
          description: fieldValue.getFieldLabelString(context, fieldValue),
          icon: fieldValue.getFieldLabelIconData(context, fieldValue),
          object: null);
    } else {
      return ViewCardItem(
          title: viewAbstract.getFieldLabel(context, field),
          description: fieldValue.toString(),
          icon: viewAbstract.getFieldIconData(field));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = viewAbstract
        .getMainFields(context: context)
        .where((element) => viewAbstract.getFieldValue(element) != null)
        .toList();
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => buildItem(context, fields[index]),
      // 40 list items
      itemCount: fields.length,
    );
  }
}

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
      // onTap: () => object?.onCardClickedView(context),
      // onLongPress: () => object?.onCardLongClickedView(context),
      title: getTextTitle(
          context, object?.getMainHeaderLabelTextOnly(context) ?? title),
      subtitle: getTextSubTitle(
          context, object?.getMainHeaderTextOnly(context) ?? description),
      leading: object != null
          ? Hero(tag: object!, child: Icon(object?.getMainIconData()))
          : Icon(icon),
      // trailing: object != null
      //     ? InkWell(
      //         onTap: () => object?.onCardTrailingClickedView(context),
      //         child: const Icon(Icons.arrow_forward_ios))
      //     : null,
    );
  }

  Text getTextTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }

  Text getTextSubTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.bodyMedium);
  }
}
