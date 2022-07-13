import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';

class EditControllerDateTime extends StatelessWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerDateTime(
      {Key? key, required this.viewAbstract, required this.field})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic fieldValue = viewAbstract.getFieldValue(field);
    return Column(children: [
      FormBuilderDateTimePicker(
        name: viewAbstract.getTag(field),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        initialDate: viewAbstract.getFieldDateTimeParse(fieldValue),
        decoration: getDecoration(context, viewAbstract, field),
      ),
      getSpace()
    ]);
  }
}
