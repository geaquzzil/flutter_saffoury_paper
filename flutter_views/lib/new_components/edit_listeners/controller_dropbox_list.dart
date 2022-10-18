import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

import '../text_bold.dart';

class DropdownStringListControllerListener extends StatelessWidget {
  String tag;
  String hint;
  List<DropdownStringListItem?> list;
  void Function(Object? object) onSelected;

  DropdownStringListControllerListener(
      {Key? key,
      required this.tag,
      required this.hint,
      required this.list,
      required this.onSelected})
      : super(key: key) {
    list.insert(0, null);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: tag,
      // decoration: getDecorationDropdownNewWithLabelAndValue(context),
      items: list
          .map((item) => DropdownMenuItem(
                value: item,
                child: item != null
                    ? TextBold(
                        text: "$hint: ${item.label}",
                        regex: item.label.toString(),
                      )
                    : Text(hint),
              ))
          .toList(),
      onChanged: (obj) {
        debugPrint("changed: $obj");
        onSelected(obj);
      },
    );
  }
}

class DropdownStringListItem {
  IconData? icon;
  String label;
  Object? value;

  DropdownStringListItem(this.icon, this.label, {this.value});
}
