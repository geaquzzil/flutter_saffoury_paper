import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

class EditControllerDropdown<T extends ViewAbstractEnum>
    extends StatelessWidget {
  T enumViewAbstract;
  ViewAbstract parent;
  String field;
  EditControllerDropdown(
      {Key? key,
      required this.parent,
      required this.enumViewAbstract,
      required this.field})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic fieldValue = enumViewAbstract;
    return Column(children: [
      FormBuilderDropdown(
        name: parent.getTag(field),
        decoration:
            getDecorationDropdown(context, parent, enumViewAbstract, field),
        hint: Text(enumViewAbstract.getMainLabelText(context)),
        items: enumViewAbstract
            .getValues()
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                      enumViewAbstract.getFieldLabelString(context, gender)),
                ))
            .toList(),
      ),
      getSpace()
    ]);
  }
}
