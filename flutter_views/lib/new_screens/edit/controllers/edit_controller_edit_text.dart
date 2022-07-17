import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';

import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

final RegExp emailRegex = new RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

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
  final textController = TextEditingController();
  bool isEnabled = false;
  @override
  void initState() {
    super.initState();

    Provider.of<ErrorFieldsProvider>(context, listen: false)
        .addField(widget.viewAbstract, widget.field);
    textController.addListener(onTextChangeListener);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }



  void onTextChangeListener() {
    if (!isEnabled) return;
    String value = textController.text;
    debugPrint("EditTextField changed");
    context.read<ErrorFieldsProvider>().notify(widget.viewAbstract,
        widget.field, widget.viewAbstract.getTag(widget.field));
    if (value.isEmpty) return;
    if (value == widget.viewAbstract.getFieldValue(widget.field).toString()) {
      return;
    }
    widget.viewAbstract =
        onChange(context, widget.viewAbstract, widget.field, value);
  }

  @override
  Widget build(BuildContext context) {
    ErrorFieldsProvider formValidationManager =
        context.read<ErrorFieldsProvider>();

    EditSubsViewAbstractControllerProvider editSubsView =
        context.watch<EditSubsViewAbstractControllerProvider>();

    ViewAbstract watchedViewAbstract = editSubsView.getViewAbstract(
            widget.viewAbstract.getFieldNameFromParent ?? "") ??
        widget.viewAbstract;

    String text = watchedViewAbstract.getFieldValue(widget.field).toString();

    isEnabled = isEnabledField(editSubsView, watchedViewAbstract);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (editSubsView.getLastTraggerdfieldTag == widget.field) return;
      if (editSubsView.getLastTraggerdViewAbstract ==
          widget.viewAbstract.getTagWithFirstParent()) return;
      debugPrint(
          "last Trggerd field name => ${editSubsView.getLastTraggerdfieldTag} current field name => ${widget.field}");
      textController.text = text;
      // Your Code Here
    });

    return Column(
      children: [
        FormBuilderTextField(
          controller: textController,
          enabled: isEnabled,
          valueTransformer: (value) {
            return value?.trim();
          },
          name: widget.viewAbstract.getTag(widget.field),
          maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
          textCapitalization:
              widget.viewAbstract.getTextInputCapitalization(widget.field),
          decoration: getDecoration(context, widget.viewAbstract, widget.field),
          keyboardType: widget.viewAbstract.getTextInputType(widget.field),
          inputFormatters:
              widget.viewAbstract.getTextInputFormatter(widget.field),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: watchedViewAbstract.getTextInputValidatorCompose(
              context, widget.field),
          onSaved: (String? value) {
            debugPrint('onSave=   $value');
          },
        ),
        getSpace()
      ],
    );
  }
}
