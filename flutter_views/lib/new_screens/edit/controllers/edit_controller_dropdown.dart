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
      {super.key,
      required this.parent,
      required this.enumViewAbstract,
      required this.field});

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      enabled: parent.isFieldEnabled(field),
      style: TextStyle(fontSize: 8),
      onChanged: (obj) => parent.onDropdownChanged(context, field, obj),
      validator: parent.getTextInputValidatorCompose(context, field),
      name: parent.getTag(field),
      initialValue: parent.getFieldValue(field, context: context),
      onSaved: (newValue) {
        parent.setFieldValue(field, newValue);
        debugPrint('FormBuilderDropdown onSave=   $newValue');
      },
      decoration:
          getDecorationDropdown(context, parent, enumViewAbstract, field),
      // hint: Text(enumViewAbstract.getMainLabelText(context)),
      items: dropdownGetValues(enumViewAbstract)
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item == null
                    ? dropdownGetEnterText(context, enumViewAbstract)
                    : enumViewAbstract.getFieldLabelString(context, item)),
              ))
          .toList(),
    );
  }
}
