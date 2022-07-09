import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:provider/provider.dart';

class EditControllerEditText extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerEditText(
      {Key? key, required this.viewAbstract, required this.field})
      : super(key: key);

  @override
  State<EditControllerEditText> createState() => _EditControllerEditTextState();
}

class _EditControllerEditTextState extends State<EditControllerEditText> {
  late final _formValidationManager;
  @override
  void initState() {
    super.initState();
    ErrorFieldsProvider errorFieldsProvider =
        Provider.of<ErrorFieldsProvider>(context, listen: false);
    _formValidationManager = errorFieldsProvider.getFormValidationManager;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilderTextField(
            valueTransformer: (value) {
              return value?.trim();
            },
            name: widget.viewAbstract.getTag(widget.field),
            initialValue: widget.viewAbstract.getFieldValue(widget.field),
            maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(widget.field),
            decoration:
                getDecoration(context, widget.viewAbstract, widget.field),
            keyboardType: widget.viewAbstract.getTextInputType(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO enabled: viewAbstract.getTextInputIsEnabled(widget.field),
            focusNode: _formValidationManager.getFocusNodeForField(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field),
            validator: _formValidationManager.wrapValidator(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field, (value) {
              return widget.viewAbstract
                  .getTextInputValidator(context, widget.field, value);
            }),
            onSaved: (String? value) {
              print('onSave=   $value');
            },
            inputFormatters:
                widget.viewAbstract.getTextInputFormatter(widget.field)),
        getSpace()
      ],
    );
  }
}
