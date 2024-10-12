// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';
import 'package:flutter_view_controller/new_components/forms/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_screens/forms/nasted/custom_tile_expansion.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
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

  // Map<String, FormAutoCompleteOptions>? getFormTextInputIsAutoCompleteMap();
  @Deprecated(
      "I think to change this to search via field and if the field is null search for all fields Use getFormTextInputIsAutoCompleteMap ")
  Map<String, bool> getTextInputIsAutoCompleteMap();
  @Deprecated(
      "I think to change this to search via field and if the field is null search for all fields Use getFormTextInputIsAutoCompleteMap ")
  Map<String, List<dynamic>> getTextInputIsAutoCompleteCustomListMap(
          BuildContext context) =>
      {};
  @Deprecated(
      "I think to change this to search via field and if the field is null search for all fields Use getFormTextInputIsAutoCompleteMap ")
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap();

  Map<String, int> getTextInputMaxLengthMap();

  Map<String, bool> isFieldRequiredMap();
  Map<String, bool> isFieldCanBeNullableMap();

  Map<String, double> getTextInputMaxValidateMap();
  Map<String, double> getTextInputMinValidateMap();

  Map<String, bool> isTextInputEnabledMap(BuildContext context) => {};

  TextInputType? getTextInputType(String field) {
    //TODO I added TextInputType.none
    return getTextInputTypeMap()[field] ?? TextInputType.none;
  }

  Map<String, List<String>>? getHasControlersAfterInputtMap(
      BuildContext context) {
    return null;
  }

  FormFieldControllerType getInputType(String field) {
    if (field == "image") return FormFieldControllerType.IMAGE;
    if (field == "date") return FormFieldControllerType.DATE_TIME;
    return FormFieldControllerType.EDIT_TEXT;
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
    textFieldController.forEach((key, value) {
      textFieldController[key]?.removeListener(() {});
      textFieldController[key]?.dispose();
    });
    textFieldController.clear();
  }

  ///should we wrap the edit view With ExpansionEditCard When its a child
  bool shouldWrapWithExpansionCardWhenChild() {
    return true;
  }

  FormOptions getFormOptions(BuildContext context, String field) {
    return FormOptions(
        type: getMirrorFieldType(field),
        isEnabled: isFieldEnabled(field),
        value: getFieldValue(field, context: context) ??
            getMirrorNewInstance(field));
  }

  Widget getFormFieldAutoComplete(
      {required BuildContext context,
      required String field,
      FormOptions? options}) {
    FormOptions options = getFormOptions(context, field);
    return FormBuilderTypeAheadCustom<String>(
        // onTap: () => controller.selection = TextSelection(
        //     baseOffset: 0, extentOffset: controller.value.text.length),
        // controller: controller,
        onChangeGetObject: (text) => text,
        valueTransformer: (value) {
          return value?.trim();
        },
        enabled: options.isEnabled,
        name: getTag(field),
        decoration: getDecoration(context, castViewAbstract(), field: field),
        initialValue: getFieldValue(field, context: context).toString(),
        maxLength: getTextInputMaxLength(field),
        textCapitalization: getTextInputCapitalization(field),
        keyboardType: getTextInputType(field),
        inputFormatters: getTextInputFormatter(field),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            scrollbarThumbAlwaysVisible: false,
            scrollbarTrackAlwaysVisible: false,
            hasScrollbar: false,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .3,
                minHeight: 100),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius:
                const BorderRadius.all(Radius.circular(kBorderRadius))),
        direction: AxisDirection.up,
        validator: (s) {
          // debugPrint(
          //     "getControllerEditTextAutoComplete field=>$field result=> ${viewAbstract.getTextInputValidatorCompose(context, field).call(s)}");
          return getTextInputValidatorCompose<String?>(context, field).call(s);
        },
        transitionBuilder: (context, suggestionsBox, animationController) {
          return FadeTransition(
            opacity: CurvedAnimation(
                parent: animationController!.view, curve: Curves.fastOutSlowIn),
            child: suggestionsBox,
          );
        },
        // suggestionsBoxDecoratio,
        itemBuilder: (context, continent) {
          return ListTile(
              leading: CircleAvatar(child: Icon(getFieldIconData(field))),
              title: Text(continent ?? "-"));
        },
        hideOnLoading: false,
        // errorBuilder: (context, error) => const CircularProgressIndicator(),
        onSaved: (newValue) {
          // viewAbstract.setFieldValue(field, newValue);
          // debugPrint(
          //     'getControllerEditTextAutoComplete onSave= $field:$newValue');
          // if (viewAbstract.getFieldNameFromParent != null) {
          //   viewAbstract.getParnet?.setFieldValue(
          //       viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
          // }
        },
        suggestionsCallback: (query) {
          if (query.isEmpty) return [];
          if (query.trim().isEmpty) return [];

          return searchByFieldName(
              field: field, searchQuery: query, context: context);
        });
  }

  Widget getFormFieldText(
      {required BuildContext context,
      required String field,
      FormOptions? options}) {
    FormOptions options = getFormOptions(context, field);

    return FormBuilderTextField(
      enabled: options.isEnabled,
      // onTap: () => controller.selection = TextSelection(
      //     baseOffset: 0, extentOffset: controller.value.text.length),
      onSubmitted: (value) =>
          debugPrint("getControllerEditText field $field value $value"),
      // controller: controller,
      // enabled: enabled,
      valueTransformer: (value) {
        // viewAbstract.getFieldValueCheckTypeChangeToCurrencyFormat(context,field)
        return value?.toString().trim();
      },
      // onChanged: (value) {
      //   debugPrint("onChange es $field:$value");
      //   if (!isChanged) {
      //     var d = formKey.currentState?.fields["comments"];
      //     debugPrint("onChange es ddd $d");
      //     // d?.didChange("300");
      //     // d?.reset();
      //     isChanged = true;
      //   }
      // },

      name: getTag(field),
      maxLength: getTextInputMaxLength(field),
      textCapitalization: getTextInputCapitalization(field),
      decoration: getDecoration(
        context,
        castViewAbstract(),
        field: field,
      ),
      keyboardType: getTextInputType(field),
      inputFormatters: getTextInputFormatter(field),
      validator: (va) =>
          getTextInputValidatorCompose<String?>(context, field).call(va),
      onSaved: (String? value) {
        // viewAbstract.setFieldValue(field, value);
        // debugPrint(
        //     'getControllerEditText onSave= $field:$value textController:${controller.text}');
        // if (viewAbstract.getFieldNameFromParent != null) {
        //   viewAbstract.getParnet?.setFieldValue(
        //       viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
        // }
      },
    );
  }

  Widget getFormFieldCheckbox(
      {required BuildContext context,
      required String field,
      FormOptions? options}) {
    options ??= getFormOptions(context, field);
    return FormBuilderCheckbox(
      enabled: options.isEnabled,
      valueTransformer: (_) => _, //TODO

      // autovalidateMode: AutovalidateMode.always,
      name: getTag(field),
      initialValue: options.type == int
          ? (options.value == true ? 1 : 0)
          : options.value ?? false,
      title: Text(getTextCheckBoxTitle(context, field)),

      subtitle: Text(getTextCheckBoxDescription(context, field)),
      onChanged: (value) {
        // viewAbstract.onCheckBoxChanged(context, field, value);
      },
      decoration: getDecorationCheckBox(),
      onSaved: (value) {
        // dynamic valueToSave =
        //     fieldType == int ? (value == true ? 1 : 0) : value ?? false;
        // viewAbstract.setFieldValue(field, valueToSave);

        // if (viewAbstract.getFieldNameFromParent != null) {
        //   viewAbstract.getParnet?.setFieldValue(
        //       viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
        // }
      },
    );
  }

  // Widget getFormFieldAutoComplete(
  //     {required BuildContext context, required String field}) {
  //   FormOptions options = getFormOptions(context, field);
  // }

  // Widget getFormFieldDropdownEnum(
  //     {required BuildContext context, required String field}) {
  //   FormOptions options = getFormOptions(context, field);
  // }
  // Widget getFormFieldChoiceChip(
  //     {required BuildContext context, required String field}) {
  //   FormOptions options = getFormOptions(context, field);
  // }
  Widget getFormFieldColorPicker(
      {required BuildContext context,
      required String field,
      FormOptions? options}) {
    options ??= getFormOptions(context, field);

    return FormBuilderColorPickerField(
      valueTransformer: (v) {
        return v?.toHex2();
      },
      colorPickerType: ColorPickerType.materialPicker,
      // expands: true,

      enabled: options.isEnabled,
      initialValue: (options.value is String)
          ? (options.value as String).fromHex()
          : null,
      name: getTag(field),
      // initialDate: (value as String?).toDateTime(),
      decoration: getDecoration(context, castViewAbstract(), field: field),
      onSaved: (newValue) {
        // viewAbstract.setFieldValue(field, newValue?.toHex2());
        // debugPrint('getContolerColorPicker onSave= $field:$newValue');
        // if (viewAbstract.getFieldNameFromParent != null) {
        //   viewAbstract.getParnet?.setFieldValue(
        //       viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
        // }
      },
    );
  }

  Widget getFormFieldDateTime(
      {required BuildContext context,
      required String field,
      FormOptions? options}) {
    options ??= getFormOptions(context, field);
    return FormBuilderDateTimePicker(
      enabled: options.isEnabled,
      valueTransformer: (value) {
        return getFieldDateTimeParseFromDateTime(value);
      },
      initialValue: (options.value as String?)?.toDateTime(),
      name: getTag(field),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      decoration: getDecoration(
        context,
        castViewAbstract(),
        field: field,
      ),
      onSaved: (newValue) {
        // viewAbstract.setFieldValue(
        //     field, viewAbstract.getFieldDateTimeParseFromDateTime(newValue));
        // debugPrint('EditControllerEditText onSave= $field:$newValue');
        // if (viewAbstract.getFieldNameFromParent != null) {
        //   viewAbstract.getParnet?.setFieldValue(
        //       viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
        // }
      },
    );
  }

  Widget getFormMainControllerWidget(
      {required BuildContext context,
      required String field,
      required GlobalKey<FormBuilderState> formKey,
      GlobalKey<FormBuilderState>? childFormKey,
      ViewAbstract? parent}) {
    FormOptions options = getFormOptions(context, field);
    Widget widget;
    bool shouldWrapWithTile = true;
    if (options.value is ViewAbstractEnum) {
      widget = const Text("ENUM");
      return const Text("IS ENUM");
      //TODO could be ChoiceChip or Dropdown
    }
    if (options.value is ViewAbstract) {
      return const Text("IS VIEW ABSTRACT");
    }
    FormFieldControllerType textFieldTypeVA = getInputType(field);
    if (textFieldTypeVA == FormFieldControllerType.DATE_TIME) {
      widget = getFormFieldDateTime(
          context: context, field: field, options: options);
    } else if (textFieldTypeVA == FormFieldControllerType.CHECKBOX) {
      shouldWrapWithTile = false;
      widget = getFormFieldCheckbox(
          context: context, field: field, options: options);
    } else if (textFieldTypeVA == FormFieldControllerType.EDIT_TEXT) {
      widget =
          getFormFieldText(context: context, field: field, options: options);
    } else if (textFieldTypeVA == FormFieldControllerType.IMAGE) {
      widget = const Text("IMAGE");
    } else if (textFieldTypeVA == FormFieldControllerType.COLOR_PICKER) {
      widget = getFormFieldColorPicker(
          context: context, field: field, options: options);
    } else if (textFieldTypeVA == FormFieldControllerType.FILE_PICKER) {
      widget = const Text("FILE");
    } else if (textFieldTypeVA == FormFieldControllerType.AUTO_COMPLETE) {
      widget = getFormFieldAutoComplete(
          context: context, field: field, options: options);
    } else {
      widget = const Text("OTHER");
    }
    if (hasParent() || !shouldWrapWithTile) {
      return widget;
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * .25),
        child: ListTileEdit(
          title: widget,
          context: context,
        ),
      );
    }

    // bool isAutoComplete = getTextInputTypeIsAutoComplete(field);
    // bool isAutoCompleteViewAbstract =
    //     getTextInputTypeIsAutoCompleteViewAbstract(field);
    // bool isAutoCompleteByCustomList =
    //     getTextInputIsAutoCompleteCustomList(context, field);
    // debugPrint(
    //     "getControllerWidget field => $field isAutoComplete=> $isAutoComplete isAutoCompleteViewAbstract=>$isAutoCompleteViewAbstract  isAutoCompleteByCustomList=>$isAutoCompleteByCustomList");
    // if (isAutoComplete) {
    //   return getControllerEditTextAutoComplete(context,
    //       enabled: isFieldEnabled(field),
    //       viewAbstract: _viewAbstract,
    //       field: field,
    //       controller: getController(context, field: field, value: fieldValue),
    //       currentScreenSize: widget.currentScreenSize);
    // }
    // if (isAutoCompleteByCustomList) {
    //   // return wrapController(Text("dsa"));
    //   return DropdownCustomListWithFormListener(
    //     viewAbstract: _viewAbstract,
    //     field: field,
    //     formKey: formKey,
    //     onSelected: (selectedObj) {
    //       _viewAbstract.setFieldValue(field, selectedObj);
    //     },
    //   );
    // }
    // if (isAutoCompleteViewAbstract) {
    //   if (textFieldTypeVA ==
    //       FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API) {
    //     throw Exception(
    //         "Do not select isAutoCompleteViewAbstract and DROP_DOWN_TEXT_SEARCH_API");
    //   }
    //   if (_viewAbstract.getParnet == null) {
    //     return getControllerEditText(context,
    //         viewAbstract: _viewAbstract,
    //         field: field,
    //         controller: getController(context, field: field, value: fieldValue),
    //         enabled: isFieldEnabled(field),
    //         currentScreenSize: widget.currentScreenSize);
    //   }
    //   return getControllerEditTextViewAbstractAutoComplete(
    //     context,
    //     viewAbstract: _viewAbstract,
    //     withDecoration: !widget.isStandAloneField,
    //     // enabled: isFieldEnabled(field),
    //     field: field,
    //     controller: getController(context,
    //         field: field, value: fieldValue, isAutoCompleteVA: true),
    //     onSelected: (selectedViewAbstract) {
    //       _viewAbstract.parent?.setFieldValue(field, selectedViewAbstract);
    //       _viewAbstract.parent
    //           ?.onDropdownChanged(context, field, selectedViewAbstract);
    //       //todo this should be setState
    //       _viewAbstract = selectedViewAbstract;
    //       refreshControllers(context, field);
    //       //removed
    //       // viewAbstractChangeProvider.change(_viewAbstract);
    //       keyExpansionTile.currentState?.manualExpand(false);

    //       // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
    //     },
    //   );
    // }
    // if (fieldValue is ViewAbstract) {
    //   fieldValue.setFieldNameFromParent(field);
    //   fieldValue.setParent(_viewAbstract);
    //   if (textFieldTypeVA == FormFieldControllerType.MULTI_CHIPS_API) {
    //     return wrapController(
    //         context: context,
    //         icon: fieldValue.getTextInputIconData(field),
    //         title: fieldValue.getTextInputLabel(context, field) ?? "-",
    //         EditControllerChipsFromViewAbstract(
    //             enabled: isFieldEnabled(field),
    //             parent: _viewAbstract,
    //             viewAbstract: fieldValue,
    //             field: field),
    //         requiredSpace: true,
    //         currentScreenSize: widget.currentScreenSize);
    //   } else if (textFieldTypeVA == FormFieldControllerType.DROP_DOWN_API) {
    //     return wrapController(
    //         context: context,
    //         icon: fieldValue.getTextInputIconData(field),
    //         title: fieldValue.getTextInputLabel(context, field) ?? "-",
    //         EditControllerDropdownFromViewAbstract(
    //             formKey: formKey,
    //             enabled: isFieldEnabled(field),
    //             parent: _viewAbstract,
    //             viewAbstract: fieldValue,
    //             field: field),
    //         requiredSpace: true,
    //         currentScreenSize: widget.currentScreenSize);
    //   } else if (textFieldTypeVA ==
    //       FormFieldControllerType.VIEW_ABSTRACT_AS_ONE_FIELD) {
    //     return BaseEditWidget(
    //       viewAbstract: fieldValue,
    //       isStandAloneField: true,
    //       currentScreenSize: widget.currentScreenSize,
    //       isTheFirst: false,
    //       onValidate: ((ob) {
    //         // String? fieldName = ob?.getFieldNameFromParent()!;
    //         debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
    //         _viewAbstract.setFieldValue(field, ob);
    //       }),
    //     );
    //   } else if (textFieldTypeVA ==
    //       FormFieldControllerType
    //           .DROP_DOWN_TEXT_SEARCH_API_AS_ONE_FIELD_NEW_IF_NOT_FOUND) {
    //   } else if (textFieldTypeVA ==
    //       FormFieldControllerType.DROP_DOWN_TEXT_SEARCH_API) {
    //     return getControllerEditTextViewAbstractAutoComplete(
    //         autoCompleteBySearchQuery: true,
    //         context,
    //         enabled: isFieldEnabled(field),
    //         viewAbstract: fieldValue,
    //         // enabled: isFieldEnabled(field),
    //         field: field,
    //         type: AutoCompleteFor.NORMAL,
    //         controller: TextEditingController(
    //             text: fieldValue.isEditing()
    //                 ? fieldValue.getMainHeaderTextOnly(context)
    //                 : ''), onSelected: (selectedViewAbstract) {
    //       // viewAbstract = selectedViewAbstract;
    //       fieldValue.parent?.setFieldValue(field, selectedViewAbstract);
    //       fieldValue.parent
    //           ?.onAutoComplete(context, field, selectedViewAbstract);

    //       refreshControllers(context, field);
    //       // //TODO viewAbstractChangeProvider.change(viewAbstract);
    //       // // context.read<ViewAbstractChangeProvider>().change(viewAbstract);
    //     }, currentScreenSize: widget.currentScreenSize);
    //   }

    //   return BaseEditWidget(
    //     viewAbstract: fieldValue,
    //     parentFormKey: formKey,
    //     currentScreenSize: widget.currentScreenSize,
    //     formKey: getSubFormState(context, field),
    //     isTheFirst: false,
    //     onValidate: ((ob) {
    //       // String? fieldName = ob?.getFieldNameFromParent()!;
    //       debugPrint("editPageNew subViewAbstract field=>$field value=>$ob");
    //       _viewAbstract.setFieldValue(field, ob);
    //       // if (ob != null) {
    //       //   viewAbstractChangeProvider.change(viewAbstract);
    //       // }
    //     }),
    //   );
    // } else if (fieldValue is ViewAbstractEnum) {
    //   return wrapController(
    //       context: context,
    //       icon: fieldValue.getFieldLabelIconData(context, fieldValue),
    //       title: fieldValue.getMainLabelText(context) ?? "-",
    //       EditControllerDropdown(
    //           parent: _viewAbstract,
    //           enumViewAbstract: fieldValue,
    //           field: field),
    //       requiredSpace: true);
    // } else {
    //   if (textFieldTypeVA == FormFieldControllerType.CHECKBOX) {
    //     return getContollerCheckBox(context,
    //         viewAbstract: _viewAbstract,
    //         field: field,
    //         value: fieldValue,
    //         enabled: isFieldEnabled(field),
    //         currentScreenSize: widget.currentScreenSize);
    //   } else if (textFieldTypeVA == FormFieldControllerType.COLOR_PICKER) {
    //     return getContolerColorPicker(context,
    //         viewAbstract: _viewAbstract,
    //         field: field,
    //         value: fieldValue,
    //         enabled: isFieldEnabled(field),
    //         currentScreenSize: widget.currentScreenSize);
    //   } else if (textFieldTypeVA == FormFieldControllerType.IMAGE) {
    //     return EditControllerFilePicker(
    //       viewAbstract: _viewAbstract,
    //       field: field,
    //     );
    //   } else {
    //     if (textInputType == TextInputType.datetime) {
    //       return getControllerDateTime(context,
    //           viewAbstract: _viewAbstract,
    //           field: field,
    //           value: fieldValue,
    //           enabled: isFieldEnabled(field),
    //           currentScreenSize: widget.currentScreenSize);
    //     } else {
    //       return getControllerEditText(context,
    //           withDecoration: true,
    //           viewAbstract: _viewAbstract,
    //           field: field,
    //           controller:
    //               getController(context, field: field, value: fieldValue),
    //           enabled: isFieldEnabled(field),
    //           currentScreenSize: widget.currentScreenSize);
    //     }
    //   }
    // }
  }

  InputDecoration getDecorationIconHintPrefix({
    required BuildContext context,
    String? prefix,
    String? suffix,
    String? hint,
    String? label,
    IconData? icon,
  }) {
    return InputDecoration(
        icon: icon == null ? null : Icon(icon),
        hintText: hint,
        border: InputBorder.none,
        errorStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).colorScheme.error),
        labelText: label,
        counterText: '',
        prefixText: prefix,
        suffixText: suffix);
  }

  InputDecoration getDecorationCheckBox() {
    return const InputDecoration(filled: false, border: InputBorder.none);
  }

  InputDecoration getDecoration(BuildContext context, ViewAbstract viewAbstract,
      {String? field, bool requireIcon = true}) {
    bool isLarge = isLargeScreen(context);
    if (field != null) {
      return getDecorationIconHintPrefix(
          context: context,
          prefix: viewAbstract.getTextInputPrefix(context, field),
          suffix: viewAbstract.getTextInputSuffix(context, field),
          hint: viewAbstract.getTextInputHint(context, field: field),
          label:
              isLarge ? null : viewAbstract.getTextInputLabel(context, field),
          icon: requireIcon == false
              ? null
              : isLarge
                  ? null
                  : viewAbstract.getTextInputIconData(field));
    } else {
      return getDecorationIconHintPrefix(
          context: context,
          icon: requireIcon == false
              ? null
              : isLarge
                  ? null
                  : viewAbstract.getMainIconData(),
          hint: viewAbstract.getTextInputHint(context));
    }
  }
}

enum FormFieldControllerType {
  EDIT_TEXT,
  DATE_TIME,
  AUTO_COMPLETE,
  COLOR_PICKER,
  FILE_PICKER,
  CHECKBOX,

  MULTI_CHIPS_API,
  DROP_DOWN_API,

  @Deprecated("")
  DROP_DOWN_TEXT_SEARCH_API,
  @Deprecated("")
  DROP_DOWN_TEXT_SEARCH_API_AS_ONE_FIELD_NEW_IF_NOT_FOUND,

  @Deprecated("")
  VIEW_ABSTRACT_AS_ONE_FIELD,

  IMAGE
}

enum FormAutoCompleteType {
  DROP_DOWN_TEXT_SEARCH_API,
  DROP_DOWN_TEXT_SEARCH_API_BY_FIELD,
}

class FormAutoCompleteOptions {
  FormAutoCompleteType type;
  List? values;
  FormAutoCompleteOptions({
    required this.type,
    this.values,
  });
}

class FormOptions {
  bool isEnabled;
  dynamic value;
  Type? type;
  FormOptions({required this.isEnabled, required this.value, this.type});
}
