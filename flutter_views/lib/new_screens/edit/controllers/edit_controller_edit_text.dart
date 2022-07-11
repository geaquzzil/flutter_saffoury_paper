import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/form_validator.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ErrorFieldsProvider formValidationManager =
        context.read<ErrorFieldsProvider>();
    if (formValidationManager == null) {
      debugPrint("FormValidationManager ==null");
    } else {
      debugPrint("FormValidationManager =! null");
    }

    return Column(
      children: [
        FormBuilderTextField(
            onChanged: (value) {
              context.read<ErrorFieldsProvider>().notify();
              if (value == null) return;
              if (value.isEmpty) return;
              if (value == widget.viewAbstract.getFieldValue(widget.field)) {
                return;
              }
              widget.viewAbstract =
                  onChange(context, widget.viewAbstract, widget.field, value);
            },
            valueTransformer: (value) {
              return value?.trim();
            },
            name: widget.viewAbstract.getTag(widget.field),
            initialValue: getFieldValue(context,
                    widget.viewAbstract.getFieldNameFromParent, widget.field)
                .toString(),
            maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(widget.field),
            decoration:
                getDecoration(context, widget.viewAbstract, widget.field),
            keyboardType: widget.viewAbstract.getTextInputType(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO enabled: viewAbstract.getTextInputIsEnabled(widget.field),
            focusNode: formValidationManager.getFocusNodeForField(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field),
            validator: formValidationManager.wrapValidator(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field, (value) {
              debugPrint("wrapValidator");
              return widget.viewAbstract
                  .getTextInputValidator(context, widget.field, value);
            }),
            onSaved: (String? value) {
              debugPrint('onSave=   $value');
            },
            inputFormatters:
                widget.viewAbstract.getTextInputFormatter(widget.field)),
        getSpace()
      ],
    );
  }
}
