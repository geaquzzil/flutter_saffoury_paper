import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

import 'ext.dart';

class EditControllerCheckBox extends StatelessWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerCheckBox(
      {super.key, required this.viewAbstract, required this.field});

  @override
  Widget build(BuildContext context) {
    Type? fieldType = viewAbstract.getMirrorFieldType(field);
    debugPrint("EditControllerCheckBox field Type=> $fieldType");
    return Column(
      children: [
        FormBuilderCheckbox(
          // activeColor: Colors.amber,
          name: viewAbstract.getTag(field),
          title: Text(viewAbstract.getTextCheckBoxTitle(context, field)),
          subtitle:
              Text(viewAbstract.getTextCheckBoxDescription(context, field)),
          onChanged: (value) {
            viewAbstract.onCheckBoxChanged(context, field, value);
          },
          onSaved: (value) {
            dynamic valueToSave =
                fieldType == int ? (value == true ? 1 : 0) : value ?? false;

            viewAbstract.setFieldValue(field, valueToSave);

            if (viewAbstract.getFieldNameFromParent != null) {
              viewAbstract.getParent?.setFieldValue(
                  viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
            }
          },
        ),
        getSpace()
      ],
    );
  }
}
