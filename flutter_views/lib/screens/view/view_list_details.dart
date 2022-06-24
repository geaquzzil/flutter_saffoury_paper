import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

import 'view_card_item.dart';

class ViewDetailsListWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  ViewDetailsListWidget({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fields = viewAbstract.getFields();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: fields.length,
        itemBuilder: (BuildContext context, int index) {
          String label = fields[index];
          print("builder $label");
          dynamic fieldValue = viewAbstract.getFieldValue(label);
          if (fieldValue == null) {
            return ViewCardItem(
                title: label, description: "null", icon: Icons.abc);
          } else if (fieldValue is ViewAbstract) {
            return ViewCardItem(
                title: "",
                description: "",
                icon: Icons.abc,
                object: fieldValue);
          } else {
            return ViewCardItem(
                title: viewAbstract.getFieldLabel(label, context),
                description: fieldValue,
                icon: viewAbstract.getFieldIconData(label));
          }
        });
  }
}