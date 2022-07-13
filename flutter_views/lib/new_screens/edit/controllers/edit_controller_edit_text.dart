import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/form_validator.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
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
  final textController = TextEditingController();
  bool isEnabled = false;
  @override
  void initState() {
    super.initState();
    Provider.of<EditSubsViewAbstractControllerProvider>(context, listen: false)
        .addListener(() {
      debugPrint("EditSubsViewAbstractControllerProvider change listnerer");
    });

    textController.addListener(onTextChangeListener);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  bool isEnabledField(EditSubsViewAbstractControllerProvider editSubsView,
      ViewAbstract viewAbstract) {
    //if this is the main viewabstract then we should enabled the text field
    debugPrint("isEnabled checking canSubmitChanges");
    if (!canSubmitChanges(viewAbstract)) return true;
    bool res = editSubsView.getIsNew(viewAbstract.getFieldNameFromParent ?? "");
    debugPrint("isEnabled checking isNew=>$res");
    return res;
  }

  void onTextChangeListener() {
    if (!isEnabled) return;
    String value = textController.text;
    debugPrint("EditTextField changed");
    context.read<ErrorFieldsProvider>().notify();
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
    // bool isEnabled=editSubsView
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          "last Trggerd field name => ${editSubsView.getLastTraggerdfieldTag} current field name => ${widget.field}");
      if (editSubsView.getLastTraggerdfieldTag == widget.field) return;
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
          //TODO enabled: viewAbstract.getTextInputIsEnabled(widget.field),
          // focusNode: formValidationManager.getFocusNodeForField(
          //     widget.viewAbstract.getTag(widget.field),
          //     widget.viewAbstract,
          //     widget.field),
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
        ),
        getSpace()
      ],
    );
  }
}
