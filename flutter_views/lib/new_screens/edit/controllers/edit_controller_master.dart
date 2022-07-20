import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_color_picker.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_edit_autocomplete.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_date.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_edit_autocomplete_va.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/edit_controller_edit_text.dart';

class EditControllerMasterWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerMasterWidget(
      {Key? key, required this.viewAbstract, required this.field})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Type fieldType = viewAbstract.getFieldType(field);
    TextInputType? textInputType = viewAbstract.getTextInputType(field);
    InputType textFieldTypeVA = viewAbstract.getInputType(field);
    if (textFieldTypeVA == InputType.COLOR_PICKER) {
      return EditControllerColorPicker(
        viewAbstract: viewAbstract,
        field: field,
      );
    }
    bool isAutoComplete = viewAbstract.getTextInputTypeIsAutoComplete(field);
    bool isAutoCompleteViewAbstract =
        viewAbstract.getTextInputTypeIsAutoCompleteViewAbstract(field);

    if (kDebugMode) {
      debugPrint("$field =  $textInputType");
    }
    // if(fieldType== ViewAbstractEnum){
    //   return EditControllerDropdown(enumViewAbstract: enumViewAbstract, field: field)
    // }
    if (isAutoComplete) {
      return EditControllerEditTextAutoComplete(
        viewAbstract: viewAbstract,
        field: field,
      );
    }
    if (isAutoCompleteViewAbstract) {
      return EditControllerEditTextAutoCompleteViewAbstract(
        viewAbstract: viewAbstract,
        field: field,
      );
    }
    if (textInputType == null) {
      return EditControllerEditText(
        viewAbstract: viewAbstract,
        field: field,
      );
    }
    if (textInputType == TextInputType.datetime) {
      return EditControllerDateTime(
        viewAbstract: viewAbstract,
        field: field,
      );
    } else {
      return EditControllerEditText(
        viewAbstract: viewAbstract,
        field: field,
      );
    }
  }
}
