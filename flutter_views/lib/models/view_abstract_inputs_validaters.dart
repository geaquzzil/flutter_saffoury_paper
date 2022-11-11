import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

abstract class ViewAbstractInputAndValidater<T>
    extends ViewAbstractController<T> {
  Map<String, TextInputType?> getTextInputTypeMap();
  Map<String, bool> getTextInputIsAutoCompleteMap();
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap();
  Map<String, int> getTextInputMaxLengthMap();

  Map<String, bool> isFieldRequiredMap();
  Map<String, bool> isFieldCanBeNullableMap();

  Map<String, double> getTextInputMaxValidateMap();
  Map<String, double> getTextInputMinValidateMap();

  Map<String, bool> isTextInputEnabledMap(BuildContext context) => {};

  Map<String, TextEditingController> textFieldController = {};

  TextInputType? getTextInputType(String field) {
    return getTextInputTypeMap()[field];
  }

  ViewAbstractControllerInputType getInputType(String field) {
    if (field == "image") return ViewAbstractControllerInputType.IMAGE;
    return ViewAbstractControllerInputType.EDIT_TEXT;
  }

  /// if the field is auto-complete view-abstract then enabled it by default
  /// if the field is not auto-complete view-abstract then check map
  /// if not found in the map then enable it by default
  bool isTextInputEnabled(BuildContext context, String field) {
    bool isAutoComplete =
        getTextInputIsAutoCompleteViewAbstractMap()[field] ?? false;
    if (isAutoComplete) return true;
    if (isEditing()) return false;
    return isTextInputEnabledMap(context)[field] ?? true;
  }

  bool isTextInputVisible(BuildContext context, String field) {
    return true;
  }

  bool getTextInputTypeIsAutoComplete(String field) {
    return getTextInputIsAutoCompleteMap()[field] ?? false;
  }

  bool getTextInputTypeIsAutoCompleteViewAbstract(String field) {
    return getTextInputIsAutoCompleteViewAbstractMap()[field] ?? false;
  }

  bool isFieldEnabled(String field) {
    return true;
  }

  bool isFieldRequired(String field) {
    return isFieldRequiredMap()[field] ?? false;
  }

  int? getTextInputMaxLength(String field) {
    return getTextInputMaxLengthMap()[field];
  }

  bool isFieldCanBeNullable(BuildContext context, String field) {
    return isFieldCanBeNullableMap()[field] ?? false;
  }

  double? getTextInputValidatorMaxValue(String field) {
    return getTextInputMaxValidateMap()[field];
  }

  double? getTextInputValidatorMinValue(String field) {
    return getTextInputMinValidateMap()[field];
  }

  IconData? getTextInputIconData(String field) {
    return getFieldIconData(field);
  }

  String getTextInputDropdownHint(BuildContext context, String field) {
    return getFieldLabel(context, field);
  }

  String? getTextInputHint(BuildContext context, {String? field}) {
    if (field == null) {
      return "${AppLocalizations.of(context)!.enter} ${getMainHeaderLabelTextOnly(context)}";
    } else {
      String? label = getTextInputLabel(context, field);
      return "${AppLocalizations.of(context)!.enter} $label";
    }
  }

  String? getTextInputLabel(BuildContext context, String field) {
    return getFieldLabel(context, field);
  }

  String? getTextInputPrefix(BuildContext context, String field) {
    return null;
  }

  String? getTextInputSuffix(BuildContext context, String field) {
    return null;
  }

  Icon? getTextInputIcon(String field) {
    return Icon(getTextInputIconData(field));
  }

  bool isNullableAlreadyFromParentCheck(BuildContext context, String field) {
    return getParnet?.getFieldValue(field) == null;
  }

  bool? canBeNullableFromParentCheck(BuildContext context, String field) {
    return getParnet?.isFieldCanBeNullable(context, field);
  }

  TextCapitalization getTextInputCapitalization(String field) {
    return TextCapitalization.sentences;
  }

  List<TextInputFormatter>? getTextInputFormatter(String field) {
    var textInputType = getTextInputType(field);
    if (textInputType == null) return null;
    if (textInputType == TextInputType.phone ||
        textInputType == TextInputType.number) {
      debugPrint("getTextInputFormatter for $field , is $textInputType");
      return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    } else {
      return null;
    }
  }

  String? Function(dynamic) getTextInputValidatorCompose(
      BuildContext context, String field) {
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    return FormBuilderValidators.compose([
      if (isFieldRequired(field)) FormBuilderValidators.required(),
      if (maxValue != null) FormBuilderValidators.max(maxValue),
      if (minValue != null) FormBuilderValidators.min(minValue),
    ]);
  }

  String? Function(ViewAbstract? viewAbstract)
      getTextInputValidatorComposeAutoComplete(
          BuildContext context, String field) {
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    debugPrint(
        "getTextInputValidatorComposeAutoComplete maxValue:$maxValue minValue:$minValue isRequired: ${isFieldRequired(field)}");
    return FormBuilderValidators.compose<ViewAbstract>([
      if (isFieldRequired(field)) FormBuilderValidators.required(),
      if (maxValue != null) FormBuilderValidators.max(maxValue),
      if (minValue != null) FormBuilderValidators.min(minValue),
    ]);
  }

  String? getTextInputValidator(
      BuildContext context, String field, String? value) {
    String fieldLabel = getFieldLabel(context, field);
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    debugPrint("checking field required $field");
    if (isFieldRequired(field)) {
      debugPrint("Field required $field value is $value");
      if (value?.isEmpty ?? false) {
        return "$fieldLabel ${AppLocalizations.of(context)!.errFieldIsIncorrect}";
      }
    }
    if (maxValue != null) {
      if (value != null && double.parse(value) > maxValue) {
        return "$fieldLabel must be less than or equal to $maxValue";
      }
    }
    if (minValue != null) {
      if (value != null && int.parse(value) < minValue) {
        return "$fieldLabel must be greater than or equal to $minValue";
      }
    }
    return null;
  }

  String getTextCheckBoxDescription(BuildContext context, String field) {
    return "getTextCheckBoxDescription $field";
  }

  String getTextCheckBoxTitle(BuildContext context, String field) {
    return getFieldLabel(context, field);
  }

  void onDropdownChanged(BuildContext context, String field, dynamic value) {
    debugPrint("onDropdownChanged field=> $field value=> $value");
    // setFieldValue(field, value);
  }

  void onCheckBoxChanged(BuildContext context, String field, dynamic value) {}

  void onTextChangeListener(BuildContext context, String field, String? value) {
    debugPrint("onTextChangeListener field=> $field value=> $value");
    // setFieldValue(field, value)
  }

  void setTextFieldControllerValue(String field, dynamic value) {
    textFieldController[getTag(field)]?.text = value.toString();
  }

  void addTextFieldController(String field, TextEditingController controller) {
    textFieldController[getTag(field)] = controller;
  }

  void dispose() {
    // textFieldController.forEach((key, value) {
    //   textFieldController[key]?.removeListener(() {});
    //   textFieldController[key]?.dispose();
    // });
    textFieldController.clear();
  }
}

enum ViewAbstractControllerInputType {
  EDIT_TEXT,
  COLOR_PICKER,
  FILE_PICKER,
  CHECKBOX,
  DROP_DOWN_API,
  IMAGE
}
