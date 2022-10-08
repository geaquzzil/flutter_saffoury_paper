import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:provider/provider.dart';

class EditControllerDateTime extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerDateTime(
      {Key? key, required this.viewAbstract, required this.field})
      : super(key: key);

  @override
  State<EditControllerDateTime> createState() => _EditControllerDateTimeState();
}

class _EditControllerDateTimeState extends State<EditControllerDateTime> {
  @override
  void initState() {
    super.initState();
    Provider.of<ErrorFieldsProvider>(context, listen: false)
        .addField(widget.viewAbstract, widget.field);
  }

  @override
  Widget build(BuildContext context) {
    dynamic fieldValue = widget.viewAbstract.getFieldValue(widget.field);
    debugPrint(
        "EditControllerDate value => $fieldValue field => ${widget.field}");
    return Column(children: [
      FormBuilderDateTimePicker(
        initialValue: (fieldValue as String?).toDateTime(),
        name: widget.viewAbstract.getTag(widget.field),
        // firstDate: DateTime(2020),
        // lastDate: DateTime(2030),
        initialDate: (fieldValue as String?).toDateTime(),
        decoration: getDecoration(context, widget.viewAbstract, widget.field),
        onSaved: (newValue) {
          widget.viewAbstract.setFieldValue(widget.field,
              widget.viewAbstract.getFieldDateTimeParseFromDateTime(newValue));
          debugPrint(
              'EditControllerEditText onSave= ${widget.field}:$newValue');
          if (widget.viewAbstract.getFieldNameFromParent != null) {
            widget.viewAbstract.getParnet?.setFieldValue(
                widget.viewAbstract.getFieldNameFromParent ?? "",
                widget.viewAbstract);
          }
        },
      ),
      getSpace()
    ]);
  }
}
