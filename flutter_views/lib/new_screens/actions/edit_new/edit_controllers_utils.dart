// ignore_for_file: constant_identifier_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_components/forms/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import '../../controllers/ext.dart';

Widget wrapController(Widget controller,
    {bool? requiredSpace,
    bool? isExpansionTile,
    CurrentScreenSize? currentScreenSize,
    bool overrideToNoneLargeScreen = false,
    bool forceNoPadding = false,
    required String title,
    required IconData? icon,
    required BuildContext context}) {
  // return controller;
  bool isLarge = isLargeScreen(context) && !overrideToNoneLargeScreen;
  if (isLarge) {
    return ListTileSameSizeOnTitle(
        leading: Text(
          softWrap: false,
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            controller,
          ],
        ),
        icon: icon);
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
          padding: forceNoPadding
              ? EdgeInsets.zero
              : (isExpansionTile ?? false)
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(
                      // vertical: 0,
                      vertical: currentScreenSize == CurrentScreenSize.DESKTOP
                          ? kDefaultPadding * .1
                          : kDefaultPadding * .5,
                    ),
          child: SizedBox(height: 40, child: controller)),
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
    bool enabled = true,
    CurrentScreenSize? currentScreenSize}) {
  Type? fieldType = viewAbstract.getMirrorFieldType(field);

  return wrapController(
      context: context,
      overrideToNoneLargeScreen: true,
      forceNoPadding: true,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderCheckbox(
        // decoration: const InputDecoration.collapsed(
        //   hintText: "",
        // ),

        // shape: ,
        // activeColor: Colors.amber,
        autovalidateMode: AutovalidateMode.always,
        name: viewAbstract.getTag(field),
        // decoration: const InputDecoration(
        //   filled: false,
        // ),
        // contentPadding: !isDecorationFilled(currentScreenSize)
        //     ? (const EdgeInsets.all(16))
        //     : EdgeInsets.zero,

        // shape: currentScreenSize == CurrentScreenSize.DESKTOP
        //     ? const CircleBorder()
        //     : null,
        initialValue:
            fieldType == int ? (value == true ? 1 : 0) : value ?? false,
        title: Text(viewAbstract.getTextCheckBoxTitle(context, field)),

        subtitle: Text(viewAbstract.getTextCheckBoxDescription(context, field)),
        onChanged: (value) {
          viewAbstract.onCheckBoxChanged(context, field, value);
        },
        decoration: const InputDecoration(filled: false),
        onSaved: (value) {
          dynamic valueToSave =
              fieldType == int ? (value == true ? 1 : 0) : value ?? false;
          viewAbstract.setFieldValue(field, valueToSave);

          if (viewAbstract.getFieldNameFromParent != null) {
            viewAbstract.getParent?.setFieldValue(
                viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
          }
        },
      ));
}

Widget getContolerColorPicker(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required dynamic value,
    bool enabled = true,
    CurrentScreenSize? currentScreenSize}) {
  debugPrint("getContolerColorPicker field : $field value:$value");

  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderColorPickerField(
        enabled: enabled,
        initialValue: (value is String) ? value.fromHex() : value?.fromHex(),
        name: viewAbstract.getTag(field),
        // initialDate: (value as String?).toDateTime(),
        decoration: getDecoration(context, viewAbstract,
            field: field, currentScreenSize: currentScreenSize),
        onSaved: (newValue) {
          viewAbstract.setFieldValue(field, newValue?.toHex2());
          debugPrint('getContolerColorPicker onSave= $field:$newValue');
          if (viewAbstract.getFieldNameFromParent != null) {
            viewAbstract.getParent?.setFieldValue(
                viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
          }
        },
      ),
      requiredSpace: true,
      currentScreenSize: currentScreenSize);
}

Widget getControllerDateTime(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required dynamic value,
    bool enabled = true,
    CurrentScreenSize? currentScreenSize}) {
  debugPrint("getControllerDateTime field : $field value:$value");
  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderDateTimePicker(
        enabled: enabled,
        initialValue: (value as String?).toDateTime(),
        name: viewAbstract.getTag(field),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        // initialDate: (value as String?).toDateTime(),
        decoration: getDecoration(context, viewAbstract,
            field: field, currentScreenSize: currentScreenSize),
        onSaved: (newValue) {
          viewAbstract.setFieldValue(
              field, viewAbstract.getFieldDateTimeParseFromDateTime(newValue));
          debugPrint('EditControllerEditText onSave= $field:$newValue');
          if (viewAbstract.getFieldNameFromParent != null) {
            viewAbstract.getParent?.setFieldValue(
                viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
          }
        },
      ),
      requiredSpace: true,
      currentScreenSize: currentScreenSize);
}

Widget getControllerDropdownCustomList(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required List<dynamic> list,
    GlobalKey<FormBuilderState>? formKey,
    required Function(dynamic selectedObj) onSelected,
    CurrentScreenSize? currentScreenSize}) {
  debugPrint("getControllerDropdownCustomList field = $field  list=> $list");
  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
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
      requiredSpace: true,
      currentScreenSize: currentScreenSize);
}

Widget getControllerDropdownViewAbstractEnum(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required ViewAbstractEnum viewAbstractEnum,
    required Function(ViewAbstractEnum? selectedEnum) onSelected,
    CurrentScreenSize? currentScreenSize}) {
  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderDropdown<ViewAbstractEnum?>(
        autovalidateMode: AutovalidateMode.always,
        onChanged: (obj) {
          viewAbstract.onDropdownChanged(context, field, obj);
          viewAbstract.setFieldValue(field, obj);
          debugPrint('getControllerDropdownViewAbstractEnum onChanged=   $obj');
          onSelected(obj);
        },
        dropdownColor: Colors.deepOrange,
        validator: viewAbstract.getTextInputValidatorCompose(context, field),
        name: viewAbstract.getTag(field),
        initialValue: viewAbstract.getFieldValue(field, context: context),
        decoration: getDecorationDropdown(
            context, viewAbstract, viewAbstractEnum, field),
        items: dropdownGetValues(viewAbstractEnum)
            .map((item) => DropdownMenuItem<ViewAbstractEnum>(
                  value: item,
                  child: Text(item == null
                      ? dropdownGetEnterText(context, viewAbstractEnum)
                      : viewAbstractEnum.getFieldLabelString(context, item)),
                ))
            .toList(),
      ),
      currentScreenSize: currentScreenSize);
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
    required Function(ViewAbstract selectedViewAbstract) onSelected,
    CurrentScreenSize? currentScreenSize}) {
  // controller.selection = TextSelection(
  //   baseOffset: 0,
  //   extentOffset: controller.text.length,
  // );

  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderTypeAheadCustom<ViewAbstract>(
          hideOnEmpty: true,
          onTap: () => controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.value.text.length),
          enabled: enabled,
          controller: controller,
          debounceDuration: const Duration(milliseconds: 750),
          onChangeGetObject: (text) => autoCompleteBySearchQuery
              ? viewAbstract.getNewInstance(values: {'text': text})
              : viewAbstract.getParent == null
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
                  ?
                  //  autoCompleteBySearchQuery
                  //     ? const InputDecoration()
                  //     : getDecoration(context, viewAbstract,
                  //         field: field, currentScreenSize: currentScreenSize)
                  getDecoration(context, viewAbstract,
                      field: field, currentScreenSize: currentScreenSize)
                  : getDecorationWithoutDecoration(
                      context, viewAbstract, field),
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

            if (viewAbstract.getParent != null) {
              viewAbstract.getParent!.setFieldValue(
                  viewAbstract.getFieldNameFromParent!, newValue);
            } else {
              viewAbstract.setFieldValue(field, newValue);
            }
            debugPrint(
                'getControllerEditTextViewAbstractAutoComplete onSave parent=> ${viewAbstract.parent.runtimeType} field = ${viewAbstract.getFieldNameFromParent}:value=> ${newValue.runtimeType}');
          },
          hideOnLoading: true,
          loadingBuilder: (context) => const SizedBox(
              width: double.infinity,
              height: 200,
              child: Center(child: CircularProgressIndicator())),
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
              } else {
                return viewAbstract.getTextInputValidatorOnAutocompleteSelected(
                    context, field, value!);
              }
            }
            return value?.getTextInputValidator(context, field,
                getEditControllerText(value.getFieldValue(field)));
          },
          suggestionsCallback: (query) {
            if (query.isEmpty) return [];
            if (query.trim().isEmpty) return [];
            if (autoCompleteBySearchQuery) {
              return viewAbstract.search(5, 0, query, context: context)
                  as Future<List<ViewAbstract>>;
              // field: field, searchQuery: query);
            }
            return viewAbstract.searchViewAbstractByTextInputViewAbstract(
                field: field, searchQuery: query, context: context);
          }),
      requiredSpace: withDecoration
          ? viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0
          : false,
      currentScreenSize: currentScreenSize);
}

Widget getControllerEditTextViewAbstractAutoCompleteNewIfNotFoundAsOneField(
    BuildContext context,
    {bool autoCompleteBySearchQuery = false,
    required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    AutoCompleteFor? type,
    bool enabled = true,
    bool withDecoration = true,
    required Function(ViewAbstract selectedViewAbstract) onSelected,
    CurrentScreenSize? currentScreenSize}) {
  // controller.selection = TextSelection(
  //   baseOffset: 0,
  //   extentOffset: controller.text.length,
  // );

  String oneFieldName = viewAbstract.getMainFields(context: context)[0];
  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderTypeAheadCustom<ViewAbstract>(
          onTap: () => controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.value.text.length),
          enabled: enabled,
          controller: controller,
          debounceDuration: const Duration(milliseconds: 750),
          onChangeGetObject: (text) {
            return autoCompleteBySearchQuery
                ? viewAbstract.getNewInstance(values: {'text': text})
                : viewAbstract.getParent == null
                    ? viewAbstract.getNewInstance()
                    : viewAbstract.parent!.getMirrorNewInstanceViewAbstract(
                        viewAbstract.fieldNameFromParent!)
              ..setFieldValue(field, text);
          },
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
                  : getDecorationWithoutDecoration(
                      context, viewAbstract, field),
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

            if (viewAbstract.getParent != null) {
              viewAbstract.getParent!.setFieldValue(
                  viewAbstract.getFieldNameFromParent!, newValue);
            } else {
              viewAbstract.setFieldValue(field, newValue);
            }
            debugPrint(
                'getControllerEditTextViewAbstractAutoComplete onSave parent=> ${viewAbstract.parent.runtimeType} field = ${viewAbstract.getFieldNameFromParent}:value=> ${newValue.runtimeType}');
          },
          hideOnLoading: false,
          loadingBuilder: (context) => const SizedBox(
              width: double.infinity,
              height: 200,
              child: Center(child: CircularProgressIndicator())),
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
              return viewAbstract.search(5, 0, query, context: context)
                  as Future<List<ViewAbstract>>;
              // field: field, searchQuery: query);
            }
            return viewAbstract.searchViewAbstractByTextInputViewAbstract(
                field: field, searchQuery: query, context: context);
          }),
      requiredSpace: withDecoration
          ? viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0
          : false,
      currentScreenSize: currentScreenSize);
}

Widget getControllerEditTextAutoComplete(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    bool enabled = true,
    CurrentScreenSize? currentScreenSize}) {
  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderTypeAheadCustom<String>(
          onTap: () => controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.value.text.length),
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
          validator: (s) {
            // debugPrint(
            //     "getControllerEditTextAutoComplete field=>$field result=> ${viewAbstract.getTextInputValidatorCompose(context, field).call(s)}");
            return viewAbstract
                .getTextInputValidatorCompose<String?>(context, field)
                .call(s);
          },
          itemBuilder: (context, continent) {
            return ListTile(title: Text(continent ?? "-"));
          },
          hideOnLoading: false,
          errorBuilder: (context, error) => const CircularProgressIndicator(),
          onSaved: (newValue) {
            viewAbstract.setFieldValue(field, newValue);
            debugPrint(
                'getControllerEditTextAutoComplete onSave= $field:$newValue');
            if (viewAbstract.getFieldNameFromParent != null) {
              viewAbstract.getParent?.setFieldValue(
                  viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
            }
          },
          suggestionsCallback: (query) {
            if (query.isEmpty) return [];
            if (query.trim().isEmpty) return [];

            return viewAbstract.searchByFieldName(
                field: field, searchQuery: query, context: context);
          }),
      requiredSpace:
          viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0,
      currentScreenSize: currentScreenSize);
}

Widget getControllerEditText(BuildContext context,
    {required ViewAbstract viewAbstract,
    required String field,
    required TextEditingController controller,
    bool withDecoration = true,
    bool enabled = true,
    CurrentScreenSize? currentScreenSize}) {
  debugPrint(
      "getControllerEditText field $field length ${viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0}  currentScreenSize $currentScreenSize");
  return wrapController(
      context: context,
      icon: viewAbstract.getTextInputIconData(field),
      title: viewAbstract.getTextInputLabel(context, field) ?? "-",
      FormBuilderTextField(
        onTap: () => controller.selection = TextSelection(
            baseOffset: 0, extentOffset: controller.value.text.length),
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
            : getDecoration(context, viewAbstract,
                field: field, currentScreenSize: currentScreenSize),
        keyboardType: viewAbstract.getTextInputType(field),
        inputFormatters: viewAbstract.getTextInputFormatter(field),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (va) => viewAbstract
            .getTextInputValidatorCompose<String?>(context, field)
            .call(va),
        onSaved: (String? value) {
          viewAbstract.setFieldValue(field, value);
          debugPrint(
              'getControllerEditText onSave= $field:$value textController:${controller.text}');
          if (viewAbstract.getFieldNameFromParent != null) {
            viewAbstract.getParent?.setFieldValue(
                viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
          }
        },
      ),
      currentScreenSize: currentScreenSize,
      requiredSpace:
          viewAbstract.getTextInputMaxLength(field).toNonNullable() == 0);
}
