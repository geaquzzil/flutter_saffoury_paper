import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class EditControllerColorPicker extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerColorPicker(
      {super.key, required this.viewAbstract, required this.field});

  @override
  State<EditControllerColorPicker> createState() =>
      _EditControllerColorPicker();
}

class _EditControllerColorPicker extends State<EditControllerColorPicker> {
  @override
  void initState() {
    super.initState();
    // Provider.of<ErrorFieldsProvider>(context, listen: false)
    //     .addField(widget.viewAbstract, widget.field);
  }

  @override
  Widget build(BuildContext context) {
    dynamic fieldValue =
        widget.viewAbstract.getFieldValue(widget.field, context: context);
    return Column(children: [
      FormBuilderColorPickerField(
        name: widget.viewAbstract.getTag(widget.field),
      ),
      getSpace()
    ]);
  }
}
