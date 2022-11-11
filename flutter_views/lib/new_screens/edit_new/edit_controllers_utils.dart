import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/custom_type_ahead.dart';
import '../edit/controllers/ext.dart';

Widget wrapController(Widget controller) {
  return Column(
    children: [controller, getSpace()],
  );
}

Widget getControllerFilePicker(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required dynamic value}) {
  return Padding(
    padding: const EdgeInsets.all(kDefaultPadding),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        viewAbstract.getCardLeadingCircleAvatar(context),
        ElevatedButton.icon(
            icon: Icon(Icons.image),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                // File file = File(result.files.single.path);
              } else {
                // User canceled the picker
              }
            },
            label: Text(AppLocalizations.of(context)!.loadImage))
      ],
    ),
  );
}

Widget getControllerDateTime(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required dynamic value,
    bool enabled = true}) {
  debugPrint("getControllerDateTime field : $field value:$value");
  return wrapController(
    FormBuilderDateTimePicker(
      enabled: enabled,
      initialValue: (value as String?).toDateTime(),
      name: viewAbstract.getTag(field),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      // initialDate: (value as String?).toDateTime(),
      decoration: getDecoration(context, viewAbstract, field: field),
      onSaved: (newValue) {
        viewAbstract.setFieldValue(
            field, viewAbstract.getFieldDateTimeParseFromDateTime(newValue));
        debugPrint('EditControllerEditText onSave= ${field}:$newValue');
        if (viewAbstract.getFieldNameFromParent != null) {
          viewAbstract.getParnet?.setFieldValue(
              viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
        }
      },
    ),
  );
}

Widget getControllerEditTextViewAbstractAutoComplete(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    required Function(ViewAbstract selectedViewAbstract) onSelected}) {
  return FormBuilderTypeAheadCustom<ViewAbstract>(
      controller: controller,
      selectionToTextTransformer: (suggestion) =>
          getEditControllerText(suggestion.getFieldValue(field)),
      name: viewAbstract.getTag(field),
      initialValue: viewAbstract,
      decoration: getDecoration(context, viewAbstract, field: field),
      maxLength: viewAbstract.getTextInputMaxLength(field),
      textCapitalization: viewAbstract.getTextInputCapitalization(field),
      keyboardType: viewAbstract.getTextInputType(field),
      autovalidateMode: AutovalidateMode.always,
      onSuggestionSelected: (value) {
        debugPrint(
            "getControllerEditTextViewAbstractAutoComplete value=>$value");
        onSelected(viewAbstract.copyWithNewSuggestion(value));
      },
      loadingBuilder: (context) => CircularProgressIndicator(),
      itemBuilder: (context, continent) {
        return ListTile(
          leading: continent.getCardLeadingCircleAvatar(context),
          title: Text(continent.getCardItemDropdownText(context)),
          subtitle: Text(continent.getCardItemDropdownSubtitle(context)),
        );
      },
      inputFormatters: viewAbstract.getTextInputFormatter(field),
      validator: viewAbstract.getTextInputValidatorCompose(context, field),
      suggestionsCallback: (query) {
        if (query.isEmpty) return [];
        if (query.trim().isEmpty) return [];

        return viewAbstract.searchViewAbstractByTextInputViewAbstract(
            field: field, searchQuery: query);
      });
}

Widget getControllerEditTextAutoComplete(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    bool enabled = true}) {
  return FormBuilderTypeAheadCustom<String>(
      controller: controller,
      valueTransformer: (value) {
        return value?.trim();
      },
      enabled: enabled,
      name: viewAbstract.getTag(field),
      decoration: getDecoration(context, viewAbstract, field: field),
      initialValue: viewAbstract.getFieldValue(field).toString(),
      maxLength: viewAbstract.getTextInputMaxLength(field),
      textCapitalization: viewAbstract.getTextInputCapitalization(field),
      keyboardType: viewAbstract.getTextInputType(field),
      inputFormatters: viewAbstract.getTextInputFormatter(field),
      autovalidateMode: AutovalidateMode.always,
      validator: viewAbstract.getTextInputValidatorCompose(context, field),
      itemBuilder: (context, continent) {
        return ListTile(title: Text(continent));
      },
      hideOnLoading: false,
      errorBuilder: (context, error) => const CircularProgressIndicator(),
      onSaved: (newValue) {
        viewAbstract.setFieldValue(field, newValue);
        debugPrint(
            'getControllerEditTextAutoComplete onSave= ${field}:$newValue');
        if (viewAbstract.getFieldNameFromParent != null) {
          viewAbstract.getParnet?.setFieldValue(
              viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
        }
      },
      suggestionsCallback: (query) {
        if (query.isEmpty) return [];
        if (query.trim().isEmpty) return [];

        return viewAbstract.searchByFieldName(field: field, searchQuery: query);
      });
}

Widget getControllerEditText(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    bool enabled = true}) {
  return wrapController(FormBuilderTextField(
    onSubmitted: (value) =>
        debugPrint("getControllerEditText field $field value $value"),
    controller: controller,
    enabled: enabled,
    valueTransformer: (value) {
      return value?.trim();
    },
    name: viewAbstract.getTag(field),
    maxLength: viewAbstract.getTextInputMaxLength(field),
    textCapitalization: viewAbstract.getTextInputCapitalization(field),
    decoration: getDecoration(context, viewAbstract, field: field),
    keyboardType: viewAbstract.getTextInputType(field),
    inputFormatters: viewAbstract.getTextInputFormatter(field),
    autovalidateMode: AutovalidateMode.always,
    validator: viewAbstract.getTextInputValidatorCompose(context, field),
    onSaved: (String? value) {
      viewAbstract.setFieldValue(field, value);
      debugPrint(
          'getControllerEditText onSave= ${field}:$value textController:${controller.text}');
      if (viewAbstract.getFieldNameFromParent != null) {
        viewAbstract.getParnet?.setFieldValue(
            viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
      }
    },
  ));
}
