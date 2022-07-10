import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/auto_complete_list_item.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/providers/actions/edits/edit_error_list_provider.dart';
import 'package:flutter_view_controller/providers/actions/edits/sub_edit_viewabstract_provider.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
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
  late final _formValidationManager;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ErrorFieldsProvider errorFieldsProvider =
        Provider.of<ErrorFieldsProvider>(context, listen: false);
    _formValidationManager = errorFieldsProvider.getFormValidationManager;
    EditSubsViewAbstractControllerProvider s =
        Provider.of<EditSubsViewAbstractControllerProvider>(context,
            listen: false);
    s.addListener(() {
      debugPrint(
          "EditSubsViewAbstractControllerProvider isChanged ${s.getList.toString()}");
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(
    //     "EditControllerEditTextAutoComplete initValue ${widget.viewAbstract.getFieldValue(widget.field).toString()} ");
    return Column(
      children: [
        FormBuilderTypeAheadCustom<String>(
            // controller: textController,
            onChanged: (value) {
              if (canSubmitChanges(widget.viewAbstract)) {
                debugPrint("isChanged to $value");
                ViewAbstract newObject =
                    widget.viewAbstract.copyWithSetNew(widget.field, value);
                context
                    .read<EditSubsViewAbstractControllerProvider>()
                    .toggleIsNew(
                        newObject.getFieldNameFromParent ?? "", newObject);
                widget.viewAbstract = newObject;
              }
            },
            valueTransformer: (value) {
              return value?.trim();
            },
            name: widget.viewAbstract.getTag(widget.field),
            initialValue: widget.viewAbstract.getFieldValue(widget.field),
            decoration:
                getDecoration(context, widget.viewAbstract, widget.field),
            maxLength: widget.viewAbstract.getTextInputMaxLength(widget.field),
            textCapitalization:
                widget.viewAbstract.getTextInputCapitalization(widget.field),
            keyboardType: widget.viewAbstract.getTextInputType(widget.field),
            inputFormatters:
                widget.viewAbstract.getTextInputFormatter(widget.field),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //TODO enabled: viewAbstract.getTextInputIsEnabled(widget.field),
            focusNode: _formValidationManager.getFocusNodeForField(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field),
            itemBuilder: (context, continent) {
              return ListTile(title: Text(continent as String));
            },
            validator: _formValidationManager.wrapValidator(
                widget.viewAbstract.getTag(widget.field),
                widget.viewAbstract,
                widget.field, (value) {
              return widget.viewAbstract
                  .getTextInputValidator(context, widget.field, value);
            }),
            onSaved: (dynamic value) {
              print('onSave=   ${value?.getHeaderTextOnly(context)}');
            },
            suggestionsCallback: (query) {
              if (query.isEmpty) return [];

              return widget.viewAbstract
                  .searchByFieldName(field: widget.field, searchQuery: query);
            }),
        getSpace()
      ],
    );
  }
}
