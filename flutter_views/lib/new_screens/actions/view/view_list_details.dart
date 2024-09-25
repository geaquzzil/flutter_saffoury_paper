import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

import 'view_card_item.dart';

class ViewDetailsListWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  ViewDetailsListWidget({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    final fields = viewAbstract.getMainFields(context: context);
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: fields.length,
        itemBuilder: (BuildContext context, int index) {
          String label = fields[index];
          debugPrint("builder $label");
          dynamic fieldValue = viewAbstract.getFieldValue(label);
          if (fieldValue == null) {
            return ViewCardItem(
               //TODO Translate
                title: label, description: "null", icon: Icons.abc);
          } else if (fieldValue is ViewAbstract) {
            return ViewCardItem(
                title: "",
                description: "",
                icon: Icons.abc,
                object: fieldValue);
          } else {
            return ViewCardItem(
                title: viewAbstract.getFieldLabel(context, label),
                description: fieldValue.toString(),
                icon: viewAbstract.getFieldIconData(label));
          }
        });
  }
}
