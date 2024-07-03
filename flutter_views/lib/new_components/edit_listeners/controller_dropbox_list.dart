import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/size_config.dart';

import '../text_bold.dart';

class DropdownStringListControllerListener extends StatelessWidget {
  String tag;
  String hint;
  List<DropdownStringListItem?> list;

  IconData? icon;
  CurrentScreenSize? currentScreenSize;
  void Function(DropdownStringListItem? object) onSelected;

  DropdownStringListControllerListener(
      {super.key,
      required this.tag,
      required this.hint,
      required this.list,
      this.icon,
      this.currentScreenSize,
      required this.onSelected}) {
    list.insert(0, null);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      // itemHeight: 50,
      name: tag,
      decoration: getDecorationIconHintPrefix(
          hint: hint, icon: icon, currentScreenSize: currentScreenSize),
      // decoration: getDecorationDropdownNewWithLabelAndValue(context),
      items: list
          .map((item) => DropdownMenuItem(
                value: item,
                child: item != null
                    ? TextBold(
                        text: "$hint: ${item.label}",
                        regex: item.label.toString(),
                      )
                    : Text(hint, style: Theme.of(context).textTheme.bodyLarge),
              ))
          .toList(),
      onChanged: (obj) {
        debugPrint("changed: $obj");
        onSelected(obj as DropdownStringListItem);
      },
    );
  }
}

class DropdownStringListItem {
  IconData? icon;
  String label;
  Object? value;
  bool? enabled;
  DropdownStringListItem(this.icon, this.label, {this.value, this.enabled});
}
