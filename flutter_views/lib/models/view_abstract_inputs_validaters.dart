// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';
import 'package:flutter_view_controller/new_components/forms/custom_type_ahead.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class ViewAbstractInputAndValidater<T>
    extends ViewAbstractController<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, TextEditingController> textFieldController = {};

  @JsonKey(includeFromJson: false, includeToJson: false)
  GlobalKey<FormBuilderState>? _formKey;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, GlobalKey<FormBuilderState>> _subformKeys = {};

  Map<String, TextInputType?> getTextInputTypeMap();
  Map<String, bool> getTextInputIsAutoCompleteMap();
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap();

  Map<String, int> getTextInputMaxLengthMap();
  Map<String, List<dynamic>> getTextInputIsAutoCompleteCustomListMap(
          BuildContext context) =>
      {};

  Map<String, bool> isFieldRequiredMap();
  Map<String, bool> isFieldCanBeNullableMap();

  Map<String, double> getTextInputMaxValidateMap();
  Map<String, double> getTextInputMinValidateMap();

  Map<String, bool> isTextInputEnabledMap(BuildContext context) => {};

  TextInputType? getTextInputType(String field) {
    return getTextInputTypeMap()[field];
  }

  Map<String, List<String>>? getHasControlersAfterInputtMap(BuildContext context) {
    return null;
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

  bool getTextInputIsAutoCompleteCustomList(
      BuildContext context, String field) {
    return getTextInputIsAutoCompleteCustomListMap(context).containsKey(field);
  }

  String getTextInputChangeViewAbstractToAutoComplete() {
    return "";
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
      // return getMainHeaderLabelTextOnly(context);
      return "${AppLocalizations.of(context)!.enter} ${getMainHeaderLabelTextOnly(context)}";
    } else {
      // return getTextInputLabel(context, field);
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

  String? getTextInputValidatorOnAutocompleteSelected(
      BuildContext context, String field, ViewAbstract value) {
    return null;
  }

  String? Function(E? val) getTextInputValidatorCompose<E>(
      BuildContext context, String field) {
    // return (d) => null;
    String passWordPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    debugPrint(
        "getTextInputValidatorCompose for $field , maxValue:  $maxValue e=> $E   e is ${E.runtimeType} e is String ${"" is E}");
    return FormBuilderValidators.compose([
      if (isFieldRequired(field)) FormBuilderValidators.required(),
      if (isFieldRequired(field)) FormBuilderValidators.minLength(1),
      if (maxValue != null) FormBuilderValidators.max(maxValue),
      if (minValue != null) FormBuilderValidators.min(minValue),
      // if (getTextInputType(field) == TextInputType.emailAddress)
      //   FormBuilderValidators.email(),
      if (getTextInputType(field) == TextInputType.name && "" is E)
        FormBuilderValidators.match(r'^\w+(\s\w+)+$',
            errorText: "Enter a valid name") as String? Function(E?),
      if (getTextInputType(field) == TextInputType.phone)
        FormBuilderValidators.equalLength(10),
      if (getTextInputType(field) == TextInputType.emailAddress && "" is E)
        FormBuilderValidators.match(
                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
                errorText:
                    "Email should contain upper,lower,digit and Special character")
            as String? Function(E?),
      if (getTextInputType(field) == TextInputType.visiblePassword && "" is E)
        FormBuilderValidators.match(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                errorText:
                    "Password should contain upper,lower,digit and Special character")
            as String? Function(E?),
      if (getTextInputType(field) == TextInputType.visiblePassword)
        FormBuilderValidators.minLength(6,
            errorText: "Password Must be more than 5 characters"),
    ]);
  }

  String? Function(ViewAbstract? viewAbstract)
      getTextInputValidatorComposeAutoComplete(
          BuildContext context, String field) {
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    debugPrint(
        "getTextInputValidator maxValue:$maxValue minValue:$minValue isRequired: ${isFieldRequired(field)}");
    return FormBuilderValidators.compose<ViewAbstract>([
      if (isFieldRequired(field)) FormBuilderValidators.required(),
      if (maxValue != null) FormBuilderValidators.max(maxValue),
      if (minValue != null) FormBuilderValidators.min(minValue),
    ]);
  }

  String? getTextInputValidatorEnum(
      BuildContext context, String field, ViewAbstractEnum? value) {
    if (isFieldRequired(field)) {
      if (value == null) {
        ViewAbstractEnum e = getMirrorNewInstanceEnum(field);
        return "${e.getMainLabelText(context)} ${AppLocalizations.of(context)!.errFieldIsIncorrect}";
      }
    }
    return null;
  }

  String? getTextInputValidatorIsRequired(
      BuildContext context, String field, dynamic value) {
    debugPrint("getTextInputValidator field=>$field value=>$value");
    if (isFieldRequired(field)) {
      if (value == null) {
        String fieldLabel = getFieldLabel(context, field);
        return "$fieldLabel ${AppLocalizations.of(context)!.errFieldIsIncorrect}";
      }
      if (value is String && value.isEmpty) {
        String fieldLabel = getFieldLabel(context, field);
        return "$fieldLabel ${AppLocalizations.of(context)!.errFieldIsIncorrect}";
      }
    }
    return null;
  }

  String? getTextInputValidator(
      BuildContext context, String field, String? value) {
    String fieldLabel = getFieldLabel(context, field);
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    debugPrint(
        "getTextInputValidator maxValue:$maxValue minValue:$minValue isRequired: ${isFieldRequired(field)}");
    if (isFieldRequired(field)) {
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

  void onDropdownChanged(BuildContext context, String field, dynamic value,
      {GlobalKey<FormBuilderState>? formKey}) {
    debugPrint("onDropdownChanged field=> $field value=> $value");
    // setFieldValue(field, value);
  }

  void onMultiChipSelected(
      BuildContext context, String field, List<dynamic>? selectedList) {
    debugPrint("onMultiChipSelected field=> $field value=> $selectedList");
    // setFieldValue(field, value);
  }

  void _notifyController(FormBuilderFieldState? v, String field) {
    debugPrint("_notifyController called");
    if (v == null) {
      debugPrint("_notifyController FormBuilderFieldState  is null");
      return;
    }
    if (v.widget is FormBuilderDropdown) {
      debugPrint("_notifyController =====> FormBuilderDropdown");
      if ((v.widget as FormBuilderDropdown).onReset != null) {
        (v.widget as FormBuilderDropdown).onReset!();
      } else {
        debugPrint(
            "notifyOtherControllers  onReset not implemented ${v.widget.name}");
      }
    } else if (v.widget is FormBuilderTextField) {
      // v.widget.

      debugPrint("_notifyController =====> FormBuilderTextField");
      setTextFieldControllerValue(field, getFieldValue(field));
    } else if (v.widget is FormBuilderTypeAheadCustom) {
      debugPrint("_notifyController =====> FormBuilderTypeAheadCustom");
      setTextFieldControllerValue(field, getFieldValue(field));
    } else {
      debugPrint("notifyOtherControllers ${v.widget.name} not supported yet");
    }
  }

  void notifyOtherControllers(
      {required BuildContext context,
      GlobalKey<FormBuilderState>? formKey,
      String? notifySpecificField}) {
    debugPrint("notifyOtherControllers");
    if (notifySpecificField != null) {
      FormBuilderFieldState? f =
          formKey?.currentState?.fields[notifySpecificField];
      _notifyController(f, notifySpecificField);
    } else {
      formKey?.currentState?.fields.forEach((key, value) {
        _notifyController(value, key);
      });
    }
  }

  List<dynamic> getMultiChipInitalValue(
    BuildContext context,
    String field,
  ) {
    throw UnimplementedError("getMultiChipInitalValue ");
  }

  void onMultiChipSaved(
      BuildContext context, String field, List<dynamic>? selectedList) {
    debugPrint("onMultiChipSaved field=> $field value=> $selectedList");
    // setFieldValue(field, value);
  }

  void onAutoComplete(BuildContext context, String field, dynamic value) {
    debugPrint("onAutoComplete field=> $field value=> $value");
    // setFieldValue(field, value);
  }

  void onCheckBoxChanged(BuildContext context, String field, dynamic value) {}

  void onTextChangeListener(BuildContext context, String field, String? value,
      {GlobalKey<FormBuilderState>? formKey}) {
    debugPrint("onTextChangeListener for $T field=> $field value=> $value");
    // setFieldValue(field, value)
  }

  void onTextChangeListenerOnSubViewAbstract(
      BuildContext context, ViewAbstract subViewAbstract, String field,
      {GlobalKey<FormBuilderState>? parentformKey}) {
    debugPrint(
        "onTextChangeListenerOnSubViewAbstract parent $T for ${subViewAbstract.runtimeType} field=> $field ");
    // setFieldValue(field, value)
  }

  void setTextFieldControllerValue(String field, dynamic value) {
    textFieldController[getTag(field)]?.text = value.toString();
    // textFieldController[getTag(field)]!.clear();
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
  MULTI_CHIPS_API,
  DROP_DOWN_API,
  DROP_DOWN_TEXT_SEARCH_API,
  DROP_DOWN_TEXT_SEARCH_API_AS_ONE_FIELD_NEW_IF_NOT_FOUND,
  VIEW_ABSTRACT_AS_ONE_FIELD,
  IMAGE
}
