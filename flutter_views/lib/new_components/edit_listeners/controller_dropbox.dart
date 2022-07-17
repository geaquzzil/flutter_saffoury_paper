import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

class DropdownControllerListener extends StatelessWidget {
  ViewAbstractEnum viewAbstractEnum;
  void Function(Object? object) onSelected;

  DropdownControllerListener(
      {Key? key, required this.viewAbstractEnum, required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: viewAbstractEnum.getMainLabelText(context),
      decoration:
          getDecorationDropdownNewWithLabelAndValue(context, viewAbstractEnum),
      items: dropdownGetValues(viewAbstractEnum)
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item == null
                    ? dropdownGetEnterText(context, viewAbstractEnum)
                    : viewAbstractEnum.getFieldLabelString(context, item)),
              ))
          .toList(),
      onChanged: (obj) => onSelected(obj),
    );
  }
}
