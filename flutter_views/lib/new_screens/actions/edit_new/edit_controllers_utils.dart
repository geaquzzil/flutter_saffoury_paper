import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/forms/custom_type_ahead.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import '../../../models/view_abstract_inputs_validaters.dart';
import '../../edit/controllers/ext.dart';

Widget wrapController(Widget controller, {bool? requiredSpace}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: controller,
      ),
      if (requiredSpace ?? false) getSpace()
    ],
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
            icon: const Icon(Icons.image),
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

Widget getContollerCheckBox(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required dynamic value,
    bool enabled = true}) {
  Type? fieldType = viewAbstract.getMirrorFieldType(field);

  return FormBuilderCheckbox(
    autovalidateMode: AutovalidateMode.always,
    name: viewAbstract.getTag(field),
    initialValue: fieldType == int ? (value == true ? 1 : 0) : value ?? false,
    title: Text(viewAbstract.getTextCheckBoxTitle(context, field)),
    subtitle: Text(viewAbstract.getTextCheckBoxDescription(context, field)),
    onChanged: (value) {
      viewAbstract.onCheckBoxChanged(context, field, value);
    },
    onSaved: (value) {
      dynamic valueToSave =
          fieldType == int ? (value == true ? 1 : 0) : value ?? false;
      viewAbstract.setFieldValue(field, valueToSave);

      if (viewAbstract.getFieldNameFromParent != null) {
        viewAbstract.getParnet?.setFieldValue(
            viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
      }
    },
  );
}

Widget getContolerColorPicker(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required dynamic value,
    bool enabled = true}) {
  debugPrint("getContolerColorPicker field : $field value:$value");

  return wrapController(
      FormBuilderColorPickerField(
        enabled: enabled,
        initialValue: (value is String) ? value.fromHex() : value?.fromHex(),
        name: viewAbstract.getTag(field),
        // initialDate: (value as String?).toDateTime(),
        decoration: getDecoration(context, viewAbstract, field: field),
        onSaved: (newValue) {
          viewAbstract.setFieldValue(field, newValue?.toHex2());
          debugPrint('getContolerColorPicker onSave= ${field}:$newValue');
          if (viewAbstract.getFieldNameFromParent != null) {
            viewAbstract.getParnet?.setFieldValue(
                viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
          }
        },
      ),
      requiredSpace: true);
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
      requiredSpace: true);
}

Widget getControllerDropdownCustomList(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required List<dynamic> list,
    GlobalKey<FormBuilderState>? formKey,
    required Function(dynamic selectedObj) onSelected}) {
  debugPrint("getControllerDropdownCustomList field = $field  list=> $list");
  return wrapController(
      FormBuilderDropdown<dynamic>(
        autovalidateMode: AutovalidateMode.always,
        onChanged: (obj) {
          viewAbstract.onDropdownChanged(context, field, obj, formKey: formKey);
          viewAbstract.setFieldValue(field, obj);
          debugPrint('getControllerDropdownCustomList onChanged=   $obj');
          onSelected(obj);
        },
        onReset: () {
          debugPrint("getControllerDropdownCustomList onReset");
        },
        validator: viewAbstract.getTextInputValidatorCompose(context, field),
        name: viewAbstract.getTag(field),
        initialValue: list.firstWhereOrNull(
            (p0) => viewAbstract.getFieldValue(field, context: context) == p0),
        decoration: getDecorationIconLabel(context,
            label: viewAbstract.getFieldLabel(context, field),
            icon: viewAbstract.getFieldIconData(field)),
        items: list
            .map((item) => DropdownMenuItem<dynamic>(
                  value: item,
                  child: Text(item == null
                      ? "${AppLocalizations.of(context)!.enter} ${viewAbstract.getFieldLabel(context, field)}"
                      : item.toString()),
                ))
            .toList(),
      ),
      requiredSpace: true);
}

Widget getControllerDropdownViewAbstractEnum(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required ViewAbstractEnum viewAbstractEnum,
    required Function(ViewAbstractEnum? selectedEnum) onSelected}) {
  return wrapController(FormBuilderDropdown<ViewAbstractEnum?>(
    autovalidateMode: AutovalidateMode.always,
    onChanged: (obj) {
      viewAbstract.onDropdownChanged(context, field, obj);
      viewAbstract.setFieldValue(field, obj);
      debugPrint('getControllerDropdownViewAbstractEnum onChanged=   $obj');
      onSelected(obj);
    },
    validator: viewAbstract.getTextInputValidatorCompose(context, field),
    name: viewAbstract.getTag(field),
    initialValue: viewAbstract.getFieldValue(field, context: context),
    decoration:
        getDecorationDropdown(context, viewAbstract, viewAbstractEnum, field),
    items: dropdownGetValues(viewAbstractEnum)
        .map((item) => DropdownMenuItem<ViewAbstractEnum>(
              value: item,
              child: Text(item == null
                  ? dropdownGetEnterText(context, viewAbstractEnum)
                  : viewAbstractEnum.getFieldLabelString(context, item)),
            ))
        .toList(),
  ));
}

enum AutoCompleteFor { TABLE, NORMAL }

Widget getControllerEditTextViewAbstractAutoComplete(BuildContext context,
    {bool autoCompleteBySearchQuery = false,
    required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    AutoCompleteFor? type,
    bool enabled = true,
    bool withDecoration = true,
    required Function(ViewAbstract selectedViewAbstract) onSelected}) {
  return wrapController(
      FormBuilderTypeAheadCustom<ViewAbstract>(
          enabled: enabled,
          controller: controller,
          onChangeGetObject: (text) => autoCompleteBySearchQuery
              ? viewAbstract.getNewInstance(searchByAutoCompleteTextInput: text)
              : viewAbstract.getParnet == null
                  ? viewAbstract.getNewInstance()
                  : viewAbstract.parent!.getMirrorNewInstanceViewAbstract(
                      viewAbstract.fieldNameFromParent!)
            ..setFieldValue(field, text),
          selectionToTextTransformer: (suggestion) {
            debugPrint(
                "getControllerEditTextViewAbstractAutoComplete suggestions => ${suggestion.searchByAutoCompleteTextInput}");
            debugPrint(
                "getControllerEditTextViewAbstractAutoComplete suggestions => ${suggestion.isNew()}");
            return autoCompleteBySearchQuery
                ? suggestion.isNew()
                    ? suggestion.searchByAutoCompleteTextInput ?? ""
                    : suggestion.getMainHeaderTextOnly(context)
                : getEditControllerText(suggestion.getFieldValue(field));
          },
          name: viewAbstract.getTag(field),
          initialValue: viewAbstract,
          decoration: type == AutoCompleteFor.NORMAL
              ? getDecorationForAutoComplete(context, viewAbstract)
              : withDecoration
                  ? autoCompleteBySearchQuery
                      ? const InputDecoration()
                      : getDecoration(context, viewAbstract, field: field)
                  : const InputDecoration(),
          maxLength: viewAbstract.getTextInputMaxLength(field),
          textCapitalization: viewAbstract.getTextInputCapitalization(field),
          keyboardType: viewAbstract.getTextInputType(field),
          autovalidateMode: AutovalidateMode.always,
          onSuggestionSelected: (value) {
            if (autoCompleteBySearchQuery) {
              onSelected(value);
            }
            debugPrint(
                "getControllerEditTextViewAbstractAutoComplete value=>$value");
            onSelected(viewAbstract.copyWithNewSuggestion(value));
          },
          onSaved: (newValue) {
            if (autoCompleteBySearchQuery) {}

            if (viewAbstract.getParnet != null) {
              viewAbstract.getParnet!.setFieldValue(
                  viewAbstract.getFieldNameFromParent!, newValue);
            } else {
              viewAbstract.setFieldValue(field, newValue);
            }
            debugPrint(
                'getControllerEditTextViewAbstractAutoComplete onSave parent=> ${viewAbstract.parent.runtimeType} field = ${viewAbstract.getFieldNameFromParent}:value=> ${newValue.runtimeType}');
          },
          hideOnLoading: false,
          debounceDuration: Duration(milliseconds: 500),
          loadingBuilder: (context) => SizedBox(
              width: double.infinity,
              height: 200,
              child: const Center(child: CircularProgressIndicator())),
          itemBuilder: (context, continent) {
            return ListTile(
              leading: continent.getCardLeadingCircleAvatar(context),
              title: Text(continent.getCardItemDropdownText(context)),
              subtitle: Text(continent.getCardItemDropdownSubtitle(context)),
            );
          },
          inputFormatters: viewAbstract.getTextInputFormatter(field),
          validator: (value) {
            if (autoCompleteBySearchQuery) {
              if (value?.isNew() ?? true) {
                return AppLocalizations.of(context)!.errFieldNotSelected(
                    viewAbstract.getMainHeaderLabelTextOnly(context));
              }
            }
            return value?.getTextInputValidator(context, field,
                getEditControllerText(value.getFieldValue(field)));
          },
          suggestionsCallback: (query) {
            if (query.isEmpty) return [];
            if (query.trim().isEmpty) return [];
            if (autoCompleteBySearchQuery) {
              return viewAbstract.search(5, 0, query)
                  as Future<List<ViewAbstract>>;
              // field: field, searchQuery: query);
            }
            return viewAbstract.searchViewAbstractByTextInputViewAbstract(
                field: field, searchQuery: query);
          }),
      requiredSpace:
          viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0);
}

Widget getControllerEditTextAutoComplete(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    bool enabled = true}) {
  return wrapController(
      FormBuilderTypeAheadCustom<String>(
          controller: controller,
          onChangeGetObject: (text) => text,
          valueTransformer: (value) {
            return value?.trim();
          },
          enabled: enabled,
          name: viewAbstract.getTag(field),
          decoration: getDecoration(context, viewAbstract, field: field),
          initialValue:
              viewAbstract.getFieldValue(field, context: context).toString(),
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

            return viewAbstract.searchByFieldName(
                field: field, searchQuery: query);
          }),
      requiredSpace:
          viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0);
}

Widget getControllerEditText(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    bool withDecoration = true,
    bool enabled = true}) {
  debugPrint(
      "getControllerEditText field $field length ${viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0} ");
  return wrapController(
      FormBuilderTextField(
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
        decoration: !withDecoration
            ? const InputDecoration()
            : getDecoration(context, viewAbstract, field: field),
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
      ),
      requiredSpace:
          viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0);
}
