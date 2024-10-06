import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/size_config.dart';

import '../../new_components/text_bold.dart';

class DropdownStringListControllerListener extends StatelessWidget {
  String tag;
  String hint;
  bool insetFirstIsSelect;
  List<DropdownStringListItem?> list;

  IconData? icon;
  CurrentScreenSize? currentScreenSize;
  void Function(DropdownStringListItem? object) onSelected;

  DropdownStringListControllerListener(
      {super.key,
      required this.tag,
      required this.hint,
      required this.list,
      this.insetFirstIsSelect = true,
      this.icon,
      this.currentScreenSize,
      required this.onSelected}) {
    if (insetFirstIsSelect) {
      list.insert(0, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      // itemHeight: 50,
      name: tag,
      // decoration: getDecorationIconHintPrefix(
      //     hint: hint, icon: icon, currentScreenSize: currentScreenSize),
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

class DropdownStringListItemWithRadio extends DropdownStringListItem {
  DropdownStringListItem? radio;
  DropdownStringListItemWithRadio(
      {required super.label, super.value, this.radio});
}

class DropdownStringListItem {
  IconData? icon;
  String label;
  Object? value;
  bool? enabled;
  bool isDivider;
  bool isRadio;
  DropdownStringListItem(
      {this.icon,
      required this.label,
      this.value,
      this.enabled,
      this.isDivider = false,
      this.isRadio = false});
}
