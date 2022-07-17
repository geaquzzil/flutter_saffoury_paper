import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:provider/provider.dart';

class EditControllerEditTextAutoComplete extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerEditTextAutoComplete(
      {Key? key, required this.viewAbstract, required this.field})
      : super(key: key);

  @override
  State<EditControllerEditTextAutoComplete> createState() =>
      _EditControllerEditTextAutoCompleteState();
}

class _EditControllerEditTextAutoCompleteState
    extends State<EditControllerEditTextAutoComplete> {
  final textController = TextEditingController();
  String lastQuery = "";
  bool isError = false;

  bool isEnabled = false;
  @override
  void initState() {
    super.initState();
    textController.addListener(onTextChangeListener);
    Provider.of<ErrorFieldsProvider>(context, listen: false)
        .addField(widget.viewAbstract, widget.field);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void onTextChangeListener() {
    String currentValue = textController.text;
    if (currentValue.isEmpty) return;
    if (currentValue == widget.viewAbstract.getFieldValue(widget.field)) return;
    // widget.viewAbstract =
    //     onChange(context, widget.viewAbstract, widget.field, currentValue);
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
        FormBuilderTypeAheadCustom<String>(
            controller: textController,
            valueTransformer: (value) {
              return value?.trim();
            },
            enabled: true,
            name: widget.viewAbstract.getTag(widget.field),
            decoration:
                getDecoration(context, widget.viewAbstract, widget.field),
            initialValue:
                widget.viewAbstract.getFieldValue(widget.field).toString(),
            maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(widget.field),
            keyboardType: widget.viewAbstract.getTextInputType(widget.field),
            inputFormatters:
                widget.viewAbstract.getTextInputFormatter(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.viewAbstract
                .getTextInputValidatorCompose(context, widget.field),
            itemBuilder: (context, continent) {
              return ListTile(title: Text(continent));
            },
            suggestionsCallback: (query) {
              if (query.isEmpty) return [];
              if (query.trim() == lastQuery.trim()) return [];
              lastQuery = query;
              return widget.viewAbstract
                  .searchByFieldName(field: widget.field, searchQuery: query);
            }),
        getSpace()
      ],
    );
  }
}
