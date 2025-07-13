// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';
import 'package:flutter_view_controller/new_components/forms/custom_type_ahead.dart';
import 'package:flutter_view_controller/new_components/forms/reative_type_ahead_from_text.dart';
import 'package:flutter_view_controller/new_components/forms/reative_type_ahead_when_no_focus.dart';
import 'package:flutter_view_controller/new_components/forms/search_choice_reactive.dart';
import 'package:flutter_view_controller/new_components/forms/validators/unique_email_async_validator.dart';
import 'package:flutter_view_controller/new_screens/actions/cruds/edit.dart';
import 'package:flutter_view_controller/new_screens/forms/nasted/expansion_edit.dart';
import 'package:flutter_view_controller/new_screens/forms/nasted/nasted_form_builder.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reactive_color_picker/reactive_color_picker.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_flutter_typeahead/reactive_flutter_typeahead.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';

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
      "I think to change this to search via field and if the field is null search for all fields Use getFormTextInputIsAutoCompleteMap Use [getInputType]")
  Map<String, bool> getTextInputIsAutoCompleteMap();
  @Deprecated(
      "I think to change this to search via field and if the field is null search for all fields Use getFormTextInputIsAutoCompleteMap Use [getInputType]")
  Map<String, List<dynamic>> getTextInputIsAutoCompleteCustomListMap(
          BuildContext context) =>
      {};
  @Deprecated(
      "I think to change this to search via field and if the field is null search for all fields Use getFormTextInputIsAutoCompleteMap Use [getInputType] ")
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

  int? getTextInputHasMaxLines(String field) {
    if (getTextInputType(field) == TextInputType.multiline) {
      return null;
    } else {
      return 1;
    }
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
    return field != "iD";
  }

  bool isFieldRequired(String field) {
    return isFieldRequiredMap()[field] ?? false;
  }

  int? getTextInputMaxLength(String field) {
    return getTextInputMaxLengthMap()[field];
  }

  ///return async list to check not contains the list
  FutureOr<List>? getTextInputValidatorIsUnique(
      BuildContext context, String field, String? currentText) {
    return null;
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
    return getParent?.isFieldCanBeNullable(context, field);
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

  Map<String, String Function(Object)>? getTextInputValidatorReactive(
      BuildContext context, String field) {
    String passWordPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    Validator? password = getValidatorsIfPassowrd(context, field);
    Validator? name = getValidtorsIfName(context, field);
    Validator? email = getValidatorsIfEmail(context, field);
    debugPrint(
        "getTextInputValidatorReactive for $field , maxValue:  $maxValue e=>  ");
    return {
      if (isFieldRequired(field))
        ValidationMessage.required: (_) => getAppLocal(context)!.errField,
      if (maxValue != null)
        ValidationMessage.max: (as) =>
            "${getAppLocal(context)!.errFieldShouldBeGreater} $as",
      if (minValue != null)
        ValidationMessage.min: (as) =>
            "${getAppLocal(context)!.errFieldShouldBeLess} $as",
      if (name != null) ValidationMessage.pattern: (as) => "TODO for name",
      if (password != null)
        ValidationMessage.pattern: (as) => "TODO for Passowrd",
      if (email != null) ValidationMessage.pattern: (as) => "TODO for email",
    };
  }

  String? Function(E? val) getTextInputValidatorCompose<E>(
      BuildContext context, String field) {
    // RegExp()
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
        FormBuilderValidators.match(RegExp(r'^\w+(\s\w+)+$'),
            errorText: "Enter a valid name") as String? Function(E?),
      if (getTextInputType(field) == TextInputType.phone)
        FormBuilderValidators.equalLength(10),
      if (getTextInputType(field) == TextInputType.emailAddress && "" is E)
        FormBuilderValidators.match(
                RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'),
                errorText:
                    "Email should contain upper,lower,digit and Special character")
            as String? Function(E?),
      if (getTextInputType(field) == TextInputType.visiblePassword && "" is E)
        FormBuilderValidators.match(
                RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
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

  @Deprecated("")
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
        value: getFieldValueCheckType(context, field));
  }

  FormOptions getFormOptionsReactive(BuildContext context, String field) {
    return FormOptions(
        type: getMirrorFieldType(field),
        isEnabled: isFieldEnabled(field),
        value: getFieldValueReturnDefualtOnNull(context, field));
  }

  Widget _optionsViewBuilder<E extends Object>(
      BuildContext context,
      String field,
      AutocompleteOnSelected<E> onSelected,
      Iterable<E> options,
      BoxConstraints constraints) {
    final selectedIndex = AutocompleteHighlightedOption.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: constraints.biggest.width * 0.8,
        height: 300,
        child: Material(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
          ),
          elevation: 4.0,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final option = options.elementAt(index);
              return GestureDetector(
                  onTap: () {
                    onSelected(option);
                  },
                  child: getAutoCompleteItemBuilder(
                    context,
                    field,
                    option,
                    isSelected: selectedIndex == index,
                  ));
            },
          ),
        ),
      ),
    );
  }

  Widget getFormFieldAutoCompleteViewAbstractResponseReactive({
    required BuildContext context,
    required String field,
    FormGroup? baseForm,
    FormOptions? options,
    double? padding,
    void Function(ViewAbstract<dynamic>)? onSuggestionSelected,
  }) {
    /// this changes auto completye field if no parent presented we dont need to present this
    ///
    if (getParent == null) {
      return getFormFieldTextReactive(
          context: context, field: field, baseForm: baseForm, options: options);
    }
    // return ReactiveTypeAheadNewObjectOnUnfocus<ViewAbstract, ViewAbstract>(
    //   decoration: getDecoration(context, options?.value),

    //   formControlName: field,
    //   // debounceDuration: Duration(seconds: 10),
    //   viewDataTypeFromTextEditingValue: (text) {
    //     return (options!.value as ViewAbstract).getNewInstance(text: text);
    //   },
    //   stringify: (value) => value.getMainHeaderTextOnly(context),
    //   suggestionsCallback: (text) {
    //     return (options!.value as ViewAbstract).search(
    //       10,
    //       0,
    //       text,
    //       context: context,
    //     ) as Future<List<ViewAbstract>>;
    //   },
    //   itemBuilder: (c, value) {
    //     return value.getAutoCompleteItemBuilder(c, field, value);
    //   },
    // );
    return ReactiveTypeAheadCustom(
      formControlName: field,
      childViewAbstractApi: castViewAbstract(),
      parentViewAbstract: getParent ?? castViewAbstract(),
      context: context,
      fieldFromParent: fieldNameFromParent ?? field,
      formGroup: baseForm!,
      fieldFromChild: field,
    );
    return ReactiveSearchChoice(
      context: context,
      formControlName: field,
      decoration: getDecoration(context, castViewAbstract(), field: field),
      viewAbstractApi: castViewAbstract(),
    );
    // return getFormFieldTextReactive(
    //     context: context, field: field, baseForm: baseForm);
    // return ReactiveTypeAheadCustom<ViewAbstract>(
    //   onChangeGetObject2: (v) => v?.getMainHeaderTextOnly(context) ?? "",
    //   onChangeGetObject: (v) => v,
    //   formControlName: field,
    //   stringify: (value) {
    //     return value?.getMainHeaderTextOnly(context) ?? "";
    //   },
    //   itemBuilder: (p0, p1) {
    //     return getAutoCompleteItemBuilder(context, field, p1);
    //   },
    //   onSuggestionSelected: (p0) {},
    //   validationMessages: getTextInputValidatorReactive(context, field),
    //   decoration: getDecoration(context, castViewAbstract(), field: field),
    //   suggestionsCallback: (query) {
    //     if (query.isEmpty) return [];
    //     if (query.trim().isEmpty) return [];
    //     if (query.length <= 2) return [];

    //     return (search(5, 0, query, context: context, cache: true)
    //         as Future<List<ViewAbstract>>);
    //   },
    // );
  }

  Widget getFormFieldMultiChipReactive(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      FormGroup? baseForm}) {
    ViewAbstract v = getValueIfListMultiChipApi(field);
    return ReactiveDropdownSearchMultiSelection<ViewAbstract, ViewAbstract>(
      formControlName: field,
      // popupProps: PopupProps.bottomSheet(
      //   showSearchBox: true,
      //   bottomSheetProps: const BottomSheetProps(
      //     constraints: BoxConstraints(maxHeight: 300),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(24),
      //         topRight: Radius.circular(24),
      //       ),
      //     ),
      //   ),
      //   title: Container(
      //     height: 50,
      //     decoration: BoxDecoration(
      //       color: Theme.of(context).primaryColorDark,
      //       borderRadius: const BorderRadius.only(
      //         topLeft: Radius.circular(20),
      //         topRight: Radius.circular(20),
      //       ),
      //     ),
      //     child: const Center(
      //       child: Text(
      //         'Country',
      //         style: TextStyle(
      //           fontSize: 24,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      validationMessages: getTextInputValidatorReactive(context, field),
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: getDecoration(context, v)),
      itemAsString: (item) {
        return item.getMainHeaderTextOnly(context);
      },
      asyncItems: (query) {
        return v.listCallNotNull(
                context: context,
                option: RequestOptions(page: 0, countPerPage: 50))
            as Future<List<ViewAbstract>>;
      },
    );
  }

  Future<List<ViewAbstract>> getEmptyList() {
    return Future.value([]);
  }

  Widget getFormFieldAutoCompleteReactive(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      FormGroup? baseForm}) {
    return LayoutBuilder(builder: (context, constraints) {
      return ReactiveRawAutocomplete<String, String>(
        // fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) => ,
        formControlName: field,
        textInputAction: TextInputAction.next,
        maxLength: getTextInputMaxLength(field),
        textCapitalization: getTextInputCapitalization(field),
        keyboardType: getTextInputType(field),
        inputFormatters: getTextInputFormatter(field),
        validationMessages: getTextInputValidatorReactive(context, field),
        decoration: getDecoration(context, castViewAbstract(), field: field),
        optionsViewOpenDirection: OptionsViewOpenDirection.up,
        optionsViewBuilder: (context, onSelected, options) =>
            _optionsViewBuilder(
                context, field, onSelected, options, constraints),
        optionsBuilder: (query) {
          if (query.text.isEmpty) return [];
          if (query.text.trim().isEmpty) return [];
          if (query.text.length <= 2) return [];

          return searchByFieldName(
              field: field, searchQuery: query.text, context: context);
        },
      );
    });
  }

  Widget getFormFieldAutoComplete(
      {required BuildContext context,
      required String field,
      required GlobalKey<FormBuilderState> parentForm,
      FormOptions? options}) {
    FormOptions options = getFormOptions(context, field);
    // GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();
    return TypeAheadField<String>(
      builder: (context, controller, focusNode) {
        controller.text = options.value as String? ?? "";

        return getFormFieldText(
            // key: fieldKey,
            field: field,
            context: context,
            options: options,
            controller: controller,
            node: focusNode);
      },
      onSelected: (a) {
        parentForm.currentState?.patchValue({field: a});
      },
      itemBuilder: (context, containt) {
        return getAutoCompleteItemBuilder(context, field, containt);
      },
      suggestionsCallback: (query) {
        if (query.isEmpty) return [];
        if (query.trim().isEmpty) return [];

        return searchByFieldName(
            field: field, searchQuery: query, context: context);
      },
    );
  }

  Widget _getAutoCompleteSuggestionBoxTransition(
      context, suggestionsBox, animationController) {
    return FadeTransition(
      opacity: CurvedAnimation(
          parent: animationController!.view, curve: Curves.fastOutSlowIn),
      child: suggestionsBox,
    );
  }

  Widget getAutoCompleteItemBuilder(
      BuildContext context, String field, dynamic continent,
      {bool? isSelected}) {
    if (continent is String) {
      return ListTile(
          selected: isSelected ?? false,
          leading: CircleAvatar(child: Icon(getFieldIconData(field))),
          title: Text(continent ?? "-"));
    }
    if (continent is ViewAbstract) {
      return ListTile(
        selected: isSelected ?? false,
        leading: continent.getCardLeadingCircleAvatar(context),
        title: Text(continent.getCardItemDropdownText(context)),
        subtitle: Text(continent.getCardItemDropdownSubtitle(context)),
      );
    }
    return Text(continent.toString());
  }

  // SuggestionsBox _getDecorationAutoCompleteSuggestionBox(BuildContext context) {
  //   return SuggestionsBox(
  //       scrollbarThumbAlwaysVisible: false,
  //       scrollbarTrackAlwaysVisible: false,
  //       hasScrollbar: false,
  //       constraints: BoxConstraints(
  //           maxHeight: MediaQuery.of(context).size.height * .3, minHeight: 100),
  //       color: Theme.of(context).colorScheme.surfaceContainerHigh,
  //       borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)));
  // }

  /// if its auto complete fioeld then we pass controller and node
  Widget getFormFieldText(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      GlobalKey<FormFieldState>? key,
      TextEditingController? controller,
      FocusNode? node,
      bool enableClearButton = false}) {
    FormOptions options = getFormOptions(context, field);

    Widget t = FormBuilderTextField(
      key: key,
      name: getTag(field),
      focusNode: node,
      controller: controller,
      enabled: options.isEnabled,

      // onChanged: (value) {
      //   controller?.text = value ?? "";
      // },

      initialValue: controller != null ? null : options.value?.toString(),

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

      maxLength: getTextInputMaxLength(field),
      textCapitalization: getTextInputCapitalization(field),
      decoration: getDecoration(context, castViewAbstract(),
          field: field,
          suffixIcon: controller != null && enableClearButton
              ? IconButton(
                  icon: Icon(Icons.clear),
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: () {
                    controller.clear();
                    node?.unfocus();
                  },
                )
              : null),
      keyboardType: getTextInputType(field),
      maxLines: getTextInputHasMaxLines(field),
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
    // if (field == 'iD') {
    //   return Visibility(
    //     visible: false,
    //     child: t,
    //   );
    // }

    return t;
  }

  Widget getFormFieldCheckbox(
      {required BuildContext context,
      required String field,
      FormOptions? options}) {
    options ??= getFormOptions(context, field);
    return FormBuilderCheckbox(
      enabled: options.isEnabled,
      valueTransformer: (a) => a, //TODO

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
      colorPickerType: ColorPickerType.materialPicker,
      // expands: true,

      enabled: options.isEnabled,
      // initialValue: (options.value is String?)
      //     ? (options.value as String?)?.fromHex()
      //     : null,
      // valueTransformer: (v) {
      //   return v?.toHex2();
      // },
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

  Widget getFormFieldAutoCompleteViewAbstractResponse({
    required BuildContext context,
    required String field,
    GlobalKey<FormFieldState>? parentForm,
    FormOptions? options,
    void Function(ViewAbstract<dynamic>)? onSuggestionSelected,
  }) {
    options ??= getFormOptions(context, field);
    GlobalKey<FormFieldState> key = GlobalKey<FormFieldState>();
    return TypeAheadField<ViewAbstract>(
      builder: (context, controller, focusNode) {
        controller.text = options?.value as String? ?? "";
        return getFormFieldText(
            // key: key,
            field: field,
            context: context,
            options: options,
            controller: controller,
            node: focusNode);
      },
      onSelected: (value) {
        debugPrint("onSeggestionSelected onSelected");
        onSuggestionSelected?.call(value);
      },
      itemBuilder: (context, containt) {
        return getAutoCompleteItemBuilder(context, field, containt);
      },
      suggestionsCallback: (query) {
        if (query.isEmpty) return [];
        if (query.trim().isEmpty) return [];

        return listCall(
            context: context,
            option: RequestOptions(searchQuery: query, countPerPage: 5));
      },
    );
    // return FormBuilderTypeAheadTupple<ViewAbstract>(
    //   selectionToTextCallback: (p0) => p0.getFieldValue(field).toString(),
    //   // initialValue: getFieldValue(field).toString(),
    //   onSuggestionSelected: onSuggestionSelected,
    //   name: getTag(field),
    //   itemBuilder: (context, containt) {
    //     return _getAutoCompleteItemBuilder(context, field, containt);
    //   },
    //   suggestionsCallback: (query) {
    //     if (query.isEmpty) return [];
    //     if (query.trim().isEmpty) return [];

    //     return (search(5, 0, query, context: context, cache: true)
    //         as Future<List<ViewAbstract>>);
    //   },
    // );
    // return FormBuilderTypeAhead<ViewAbstract>(
    //     suggestionsBoxDecoration:
    //         _getDecorationAutoCompleteSuggestionBox(context),
    //     transitionBuilder: _getAutoCompleteSuggestionBoxTransition,
    //     // suggestionsBoxDecoratio,
    //     itemBuilder: (context, continent) {
    //       return _getAutoCompleteItemBuilder(context, field, continent);
    //     },
    //     hideOnLoading: false,
    //     hideOnEmpty: true,
    //     // onTap: () => controller.selection = TextSelection(
    //     //     baseOffset: 0, extentOffset: controller.value.text.length),
    //     enabled: options.isEnabled,
    //     // controller: controller,
    //     debounceDuration: const Duration(milliseconds: 750),
    //     // onChangeGetObject: (text) {
    //     //   debugPrint("getFormFieldAutoCompleteViewAbstractResponse soso $text");
    //     //   return (options?.value as ViewAbstract)
    //     //       .getNewInstance(searchByAutoCompleteTextInput: text);
    //     //   // return autoCompleteBySearchQuery
    //     //   //     ? viewAbstract.getNewInstance(searchByAutoCompleteTextInput: text)
    //     //   //     : viewAbstract.getParnet == null
    //     //   //         ? viewAbstract.getNewInstance()
    //     //   //         : viewAbstract.parent!.getMirrorNewInstanceViewAbstract(
    //     //   //             viewAbstract.fieldNameFromParent!)
    //     //   //   ..setFieldValue(field, text);
    //     // },
    //     selectionToTextTransformer: (suggestion) {
    //       return suggestion.getFieldValue(field).toString();
    //       // debugPrint(
    //       //     "getControllerEditTextViewAbstractAutoComplete suggestions => ${suggestion.searchByAutoCompleteTextInput}");
    //       // debugPrint(
    //       //     "getControllerEditTextViewAbstractAutoComplete suggestions => ${suggestion.isNew()}");
    //       // return suggestion.getFieldValue(field, context: context);
    //       // return autoCompleteBySearchQuery
    //       //     ? suggestion.isNew()
    //       //         ? suggestion.searchByAutoCompleteTextInput ?? ""
    //       //         : suggestion.getMainHeaderTextOnly(context)
    //       //     : getEditControllerText(suggestion.getFieldValue(field));
    //     },
    //     name: getTag(field),
    //     initialValue: getFieldValue(field),
    //     decoration: getDecoration(
    //       context,
    //       castViewAbstract(),
    //       field: field,
    //     ),
    //     // maxLength: getTextInputMaxLength(field),
    //     // inputFormatters: getTextInputFormatter(field),
    //     // textCapitalization: getTextInputCapitalization(field),
    //     // keyboardType: getTextInputType(field),
    //     onSuggestionSelected: onSuggestionSelected,
    //     onSaved: (newValue) {
    //       // if (autoCompleteBySearchQuery) {}

    //       // if (viewAbstract.getParnet != null) {
    //       //   viewAbstract.getParnet!
    //       //       .setFieldValue(viewAbstract.getFieldNameFromParent!, newValue);
    //       // } else {
    //       //   viewAbstract.setFieldValue(field, newValue);
    //       // }
    //       // debugPrint(
    //       //     'getControllerEditTextViewAbstractAutoComplete onSave parent=> ${viewAbstract.parent.runtimeType} field = ${viewAbstract.getFieldNameFromParent}:value=> ${newValue.runtimeType}');
    //     },
    //     // loadingBuilder: (context) => const SizedBox(
    //     //     width: double.infinity,
    //     //     height: 200,
    //     //     child: Center(child: CircularProgressIndicator())),

    //     validator: (value) {
    //       return null;
    //       // if (autoCompleteBySearchQuery) {
    //       //   if (value?.isNew() ?? true) {
    //       //     return AppLocalizations.of(context)!
    //       //         .errFieldNotSelected(getMainHeaderLabelTextOnly(context));
    //       //   } else {
    //       //     return getTextInputValidatorOnAutocompleteSelected(
    //       //         context, field, value!);
    //       //   }
    //       // }
    //       // return value?.getTextInputValidator(context, field,
    //       //     getEditControllerText(value.getFieldValue(field)));
    //     },
    //     suggestionsCallback: (query) {
    //       if (query.isEmpty) return [];
    //       if (query.trim().isEmpty) return [];

    //       return (search(5, 0, query, context: context, cache: true)
    //           as Future<List<ViewAbstract>>);
    //       // if (autoCompleteBySearchQuery) {
    //       //   return search(5, 0, query, context: context)
    //       //       as Future<List<ViewAbstract>>;
    //       // }
    //       // return searchViewAbstractByTextInputViewAbstract(
    //       //     field: field, searchQuery: query, context: context);
    //     });
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
      lastDate: DateTime(2030),
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

  Widget getFormFieldColorPickerReactive(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      FormGroup? baseForm}) {
    return ReactiveSliderColorPicker(
      formControlName: field,

      // pickerAreaHeightPercent: 0.7,
      displayThumbColor: true,

      // decoration: getDecoration(context, castViewAbstract(), field: field),

      // labelTypes: const [],
      validationMessages: getTextInputValidatorReactive(context, field),

      // hexInputController: textController,
      // portraitOnly: true,
      // colorPickerBuilder: (pickColor, color) {
      //   return ListTile(
      //     title: Text(getFieldLabel(context, field)),
      //     trailing: Container(
      //       width: 30,
      //       height: 30,
      //       decoration: BoxDecoration(
      //         color: color,
      //         borderRadius: BorderRadius.circular(kBorderRadius),
      //         // border:
      //         //     Border.all(color: Theme.of(context).colorScheme.outline),
      //       ),
      //     ),
      //     onTap: pickColor,
      //   );
      // }
    );
  }

  Widget getFormFieldTextReactive(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      FormGroup? baseForm,
      TextEditingController? controller,
      FocusNode? node,
      void Function(FormControl<dynamic>)? onChanged,
      void Function(FormControl<dynamic>)? onTap,
      bool readOnly = false,
      bool enableClearButton = false}) {
    return ReactiveTextField(
      onChanged: onChanged,
      controller: controller,
      focusNode: node,
      formControlName: field,
      onTap: onTap,
      readOnly: readOnly,
      textInputAction: TextInputAction.next,
      maxLength: getTextInputMaxLength(field),
      textCapitalization: getTextInputCapitalization(field),
      keyboardType: getTextInputType(field),
      inputFormatters: getTextInputFormatter(field),
      validationMessages: getTextInputValidatorReactive(context, field),
      maxLines: getTextInputHasMaxLines(field),
      decoration: getDecoration(context, castViewAbstract(),
          field: field,
          suffixIcon: controller?.text.isEmpty == true
              ? null
              : controller != null && enableClearButton
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      color: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        controller.clear();
                        node?.unfocus();
                      },
                    )
                  : null),
    );
  }

  Widget getReactiveViewAbstractField(
      {required BuildContext context,
      required FormGroup baseForm,
      required String field,
      required FormOptions options}) {
    // return ReactiveTypeAhead<String, ViewAbstract>(
    //   decoration: getDecoration(context, options.value),
    //   validationMessages: getTextInputValidatorReactive(context, field),
    //   formControlName: field,
    //   stringify: (value) => value.getMainHeaderTextOnly(context),
    //   viewDataTypeFromTextEditingValue: (p0) {
    //     return (options.value as ViewAbstract).getNewInstance(text: p0);
    //   },
    //   suggestionsCallback: (text) {
    //     return (options.value as ViewAbstract).search(
    //       10,
    //       0,
    //       text,
    //       context: context,
    //     ) as Future<List<ViewAbstract>>;
    //   },
    //   itemBuilder: (c, value) {
    //     return value.getAutoCompleteItemBuilder(c, field, value);
    //   },
    // );
    return ReactiveTypeAheadNewObjectOnUnfocus<ViewAbstract, ViewAbstract>(
      decoration: getDecoration(context, options.value),
      validationMessages: getTextInputValidatorReactive(context, field),
      formControlName: field,
      // debounceDuration: Duration(seconds: 10),
      viewDataTypeFromTextEditingValue: (text) {
        return (options.value as ViewAbstract).getNewInstance(text: text);
      },
      stringify: (value) => value.getMainHeaderTextOnly(context),
      suggestionsCallback: (text) {
        return (options.value as ViewAbstract).listCall(
            context: context,
            option: RequestOptions(searchQuery: text, countPerPage: 10));
      },
      itemBuilder: (c, value) {
        return value.getAutoCompleteItemBuilder(c, field, value);
      },
    );
  }

  Widget getReactiveFormDropbox(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      FormGroup? baseForm}) {
    // return Text("dsa");

    return ReactiveDropdownSearch<ViewAbstractEnum, ViewAbstractEnum>(
      formControlName: field,
      // showClearButton: true,
      validationMessages: getTextInputValidatorReactive(context, field),

      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration:
              getDecorationDropdown(context, options!.value)),
      itemAsString: (item) {
        return item.getFieldLabelString(context, item);
        // return ListTile(
        //   leading: Icon(item.getMainIconData()),
        //   title: Text(item.getFieldLabelString(context, item)),
        // );
      },

      // suffixProps: const DropdownSuffixProps(
      //   dropdownButtonProps: DropdownButtonProps(
      //     iconOpened: Padding(
      //       padding: EdgeInsets.only(right: 120.0),
      //       child: Icon(Icons.ac_unit, size: 24),
      //     ),
      //     iconClosed: Padding(
      //       padding: EdgeInsets.only(right: 120.0),
      //       child: Icon(Icons.ac_unit, size: 24),
      //     ),
      //   ),
      // ),
      // popupProps: PopupProps.menu(
      //   showSelectedItems: true,
      //   disabledItemFn: (s) {
      //     return s.startsWith('I');
      //   },
      // ),
      // items: (options?.value as ViewAbstractEnum?)
      //         ?.getValues()
      //         .map((e) =>
      //             (e as ViewAbstractEnum).getFieldLabelString(context, e))
      //         .toList() ??
      //     []
      items: (options.value as ViewAbstractEnum?)?.getValues().cast() ?? [],
    );
    // ReactiveSliderColorPicker
    return ReactiveDropdownField(
      formControlName: field,
      validationMessages: getTextInputValidatorReactive(context, field),
      items: getDropDownMenu(context, options.value as ViewAbstractEnum),
      decoration: getDecorationDropdown(context, options.value),
    );
  }

  Widget getFormFieldCheckboxReactive(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      FormGroup? baseForm}) {
    return ReactiveCheckboxListTile(
        formControlName: field,
        title: Text(getTextCheckBoxTitle(context, field)),
        subtitle: Text(getTextCheckBoxDescription(context, field)));
  }

  Widget getFormFieldDateTimeReactive(
      {required BuildContext context,
      required String field,
      FormOptions? options,
      FormGroup? baseForm}) {
    options ??= getFormOptions(context, field);
    return ReactiveDateTimePicker(
      // fieldLabelText: "sda",
      dateFormat: DateFormat(dateFormatString, 'en-US'),
      type: ReactiveDatePickerFieldType.dateTime,
      firstDate: "2020-01-01".toDateTimeOnlyDate(),
      lastDate: "2030-01-01".toDateTimeOnlyDate(),
      decoration: getDecoration(context, castViewAbstract(), field: field),
      formControlName: field,
      // builder: (context, picker, child) {
      //   // return getFormFieldTextReactive(
      //   //     context: context,
      //   //     field: field,
      //   //     baseForm: baseForm,
      //   //     options: options,
      //   //     onTap: (d) {
      //   //       picker.showPicker();

      //   //     });
      //   return Row(
      //     children: [
      //       IconButton(
      //         iconSize: getIconSize(context),
      //         onPressed: picker.showPicker,
      //         icon: Icon(Icons.date_range),
      //       ),
      //       ReactiveValueListenableBuilder<String>(
      //         formControlName: field,
      //         builder: (context, control, child) {
      //           return Text(control.isNull
      //               //Todo translate
      //               ? 'isNotSet'
      //               : control.value!);
      //         },
      //       ),
      //       Spacer(),
      //       TextButton(
      //         onPressed: picker.showPicker,
      //         //Todo translate
      //         child: Text("Change"),
      //       ),
      //     ],
      //   );
      // }
    );
    // enabled: options.isEnabled,
    // valueTransformer: (value) {
    //   return getFieldDateTimeParseFromDateTime(value);
    // },
    // initialValue: (options.value as String?)?.toDateTime(),
    // name: getTag(field),
    // firstDate: DateTime(2020),
    // lastDate: DateTime(2030),
    // decoration: getDecoration(
    //   context,
    //   castViewAbstract(),
    //   field: field,
    // ),
    // onSaved: (newValue) {
    //   // viewAbstract.setFieldValue(
    //   //     field, viewAbstract.getFieldDateTimeParseFromDateTime(newValue));
    //   // debugPrint('EditControllerEditText onSave= $field:$newValue');
    //   // if (viewAbstract.getFieldNameFromParent != null) {
    //   //   viewAbstract.getParnet?.setFieldValue(
    //   //       viewAbstract.getFieldNameFromParent ?? "", viewAbstract);
    //   // }
  }

  FormGroup getViewAbstractGroup(
      BuildContext context, ViewAbstract viewAbstract) {
    return viewAbstract.getBaseFormGroup(context);
  }

  //  if (isFieldRequired(field)) ValidationMessage.required:(_)=>getAppLocal(context)!.errField,
  //     if (maxValue != null) ValidationMessage.max(maxValue),
  //     if (minValue != null) ValidationMessage.minLength(minValue),
  //     // if (getTextInputType(field) == TextInputType.emailAddress)
  //     //   FormBuilderValidators.email(),
  //     if (getTextInputType(field) == TextInputType.name && "" is E)
  //       FormBuilderValidators.match(RegExp(r'^\w+(\s\w+)+$'),
  //           errorText: "Enter a valid name") as String? Function(E?),
  //     if (getTextInputType(field) == TextInputType.phone)
  //       ValidationMessage.(10),
  //     if (getTextInputType(field) == TextInputType.emailAddress && "" is E)
  //       FormBuilderValidators.match(
  //               RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'),
  //               errorText:
  //                   "Email should contain upper,lower,digit and Special character")
  //           as String? Function(E?),
  //     if (getTextInputType(field) == TextInputType.visiblePassword && "" is E)
  //       FormBuilderValidators.match(
  //               RegExp(
  //                   r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
  //               errorText:
  //                   "Password should contain upper,lower,digit and Special character")
  //           as String? Function(E?),
  //     if (getTextInputType(field) == TextInputType.visiblePassword)
  //       FormBuilderValidators.minLength(6,
  //           errorText: "Password Must be more than 5 characters"),
  //     });
  Validator<dynamic>? getValidatorsIfEmail(BuildContext context, String field) {
    if (getTextInputType(field) == TextInputType.emailAddress) {
      return Validators.email;
    }
    return null;
  }

  AsyncValidator<dynamic>? getValidtorsIfUnique(
      BuildContext context, String field) {
    FutureOr<List>? future =
        getTextInputValidatorIsUnique(context, field, null);
    return future == null
        ? null
        : UniqueValidator2(
            futureText: (value) {
              return getTextInputValidatorIsUnique(context, field, value)!;
            },
            initialValue: getFieldValue(field, context: context));
  }

  Validator<dynamic>? getValidtorsIfName(BuildContext context, String field) {
    if (getTextInputType(field) == TextInputType.name) {
      return Validators.pattern(RegExp(r'^\w+(\s\w+)+$'),
          //TODO Enter a valid name

          validationMessage: "Enter a valid name");
    }
    return null;
  }

  Validator<dynamic>? getValidatorsIfPassowrd(
      BuildContext context, String field) {
    if (getTextInputType(field) == TextInputType.visiblePassword) {
      return Validators.pattern(
          RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
          //TODO Password should contain upper,lower,digit and Special character todo translate
          validationMessage:
              "Password should contain upper,lower,digit and Special character");
    }
    return null;
  }

  FormControl getFormControl(BuildContext context, String e, {bool? disabled}) {
    if (e == 'iD') {
      return FormControl<int>();
    }
    Type? fieldType = getMirrorFieldType(e);

    debugPrint(
        "castFieldValue type is field:$e type:$fieldType isViewAbstractEnum:${fieldType == ViewAbstractEnum}");
    int? maxLength = getTextInputMaxLength(e);
    double? minValue = getTextInputValidatorMinValue(e);
    double? maxValue = getTextInputValidatorMaxValue(e);
    Validator? password = getValidatorsIfPassowrd(context, e);
    Validator? name = getValidtorsIfName(context, e);
    Validator? email = getValidatorsIfEmail(context, e);
    AsyncValidator? isUnique = getValidtorsIfUnique(context, e);
    FormFieldControllerType type = getInputType(e);
    List<Validator> l = [
      if (isFieldRequired(e)) Validators.required,
      if (maxLength != null) Validators.maxLength(maxLength),
      if (minValue != null) Validators.min(minValue),
      if (maxValue != null) Validators.max(maxValue),
      if (name != null) name,
      if (password != null) password,
      if (email != null) Validators.email,
    ];

    if (type == FormFieldControllerType.COLOR_PICKER) {
      return FormControl<Color>(
        validators: l,
        disabled: disabled ?? !isFieldEnabled(e),
      );
    } else if (type == FormFieldControllerType.DATE_TIME) {
      return FormControl<DateTime>(
        validators: l,
        disabled: disabled ?? !isFieldEnabled(e),
      );
    } else if (type == FormFieldControllerType.MULTI_CHIPS_API) {
      return FormControl<List<ViewAbstract>>(
        validators: l,
        disabled: disabled ?? !isFieldEnabled(e),
      );
    }

    // value = value ?? "";
    if (fieldType == int) {
      return FormControl<int>(
        validators: l,
        asyncValidators: [if (isUnique != null) isUnique],
        disabled: disabled ?? !isFieldEnabled(e),
      );
    } else if (fieldType == num) {
      return FormControl<num>(
        validators: l,
        asyncValidators: [if (isUnique != null) isUnique],
        disabled: disabled ?? !isFieldEnabled(e),
      );
    } else if (fieldType == double) {
      return FormControl<double>(
        validators: l,
        asyncValidators: [if (isUnique != null) isUnique],
        disabled: disabled ?? !isFieldEnabled(e),
      );
    } else if (fieldType == String) {
      return FormControl<String>(
        validators: l,
        asyncValidators: [if (isUnique != null) isUnique],
        disabled: disabled ?? !isFieldEnabled(e),
      );
    } else if (fieldType == ViewAbstract) {
      debugPrint("fieldType= =ViewAbstract");
      return FormControl<ViewAbstract>(
        validators: l,
        asyncValidators: [if (isUnique != null) isUnique],
        disabled: disabled ?? !isFieldEnabled(e),
      );
    } else {
      dynamic value = getFieldValueReturnDefualtOnNull(context, e);
      if (value is ViewAbstractEnum) {
        debugPrint("fieldType= =ViewAbstractEnum ");
        return FormControl<ViewAbstractEnum>(
          validators: l,
          asyncValidators: [if (isUnique != null) isUnique],
          disabled: disabled ?? !isFieldEnabled(e),
        );
      } else if (value is ViewAbstract) {
        debugPrint("value is = =ViewAbstract");
        return FormControl<ViewAbstract>(
          validators: l,
          asyncValidators: [if (isUnique != null) isUnique],
          disabled: disabled ?? !isFieldEnabled(e),
        );
      }
      return FormControl(
        validators: l,
        asyncValidators: [if (isUnique != null) isUnique],
        disabled: disabled ?? !isFieldEnabled(e),
      );
    }
  }

  List<String> getMainFieldsForForms({BuildContext? context}) {
    return ['iD', ...getMainFields(context: context)];
  }

  Map<String, dynamic> getObjectFromForm(BuildContext context, FormGroup form) {
    return {'iD': iD, ...form.value};
  }

  FormGroup getBaseFormGroup(BuildContext context,
      {FormBuilderOptions? buildOptions,
      ViewAbstract? parent,
      bool? disabled}) {
    Map<String, Object> controls = {};

    getMainFieldsForForms(context: context).forEach((e) {
      if (isViewAbstract(e)) {
        bool? isNull;
        if (isFieldCanBeNullable(context, e)) {
          isNull = getFieldValue(e, context: context) == null;
          controls[getControllerKey(e, extras: "n")] =
              FormControl<bool>(value: isNull);
        }
        ViewAbstract v =
            (getFieldValueReturnDefualtOnNull(context, e) as ViewAbstract);
        if (buildOptions?.canContinue(parent: parent) ?? true) {
          controls[e] = v.getBaseFormGroup(context,
              buildOptions: buildOptions,
              parent: castViewAbstract(),
              disabled: isNull);
        } else {
          FormControl formControl =
              getFormControl(context, e, disabled: disabled);
          dynamic value = getFieldValueReturnDefualtOnNull(context, e);
          formControl.value = value;

          controls[e] = formControl;
        }
      } else {
        FormControl formControl =
            getFormControl(context, e, disabled: disabled);
        dynamic value = getFieldValueReturnDefualtOnNull(context, e);
        if (value != null) {
          FormFieldControllerType type = getInputType(e);
          if (e == 'iD') {
          } else if (type == FormFieldControllerType.COLOR_PICKER) {
            value = (value as String).fromHex();
          } else if (type == FormFieldControllerType.DATE_TIME) {
            value = (value as String).toDateTime();
          }
        }
        formControl.value = value;

        controls[e] = formControl;
      }
    });

    if (isListable()) {
      List<FormGroup> g = List.empty(growable: true);
      List<ViewAbstract> listable = castListableInterface().getListableList();
      for (var v in listable) {
        g.add(v.getBaseFormGroup(context, parent: castViewAbstract()));
      }
      debugPrint(
          "ReactiveFormArray  isListable details listable length:${listable.length} ${g.length} $g");
      String keyName = castListableInterface()
          .getListableAddFromManual(context)
          .getTableNameApi()!;
      controls[keyName] = FormArray(g, validators: [
        if (castListableInterface().isListableRequired(context))
          Validators.required
      ]);
    }
    FormGroup f = fb.group(controls, [
      // if (parent != null)
      // NotRequiredValidator(
      //     context: context, field: fieldNameFromParent!, parent: parent)
    ]);
    if (disabled == true) {
      f.markAsDisabled();
    }
    return f;
  }

  Widget getReactiveForm2(
      {required BuildContext context,
      required FormGroup childGroup,
      Widget? child}) {
    return ReactiveForm(
      formGroup: childGroup,
      child: child ??
          Column(
            spacing: 10,
            children: getMainFieldsForForms(context: context).map((e) {
              debugPrint("ReactiveFormArray getReactiveForm2 field $e");
              return getFormMainControllerWidgetReactive(
                  context: context,
                  field: e,
                  baseForm: childGroup,
                  parent: castViewAbstract());
            }).toList(),
          ),
    );
  }

  Widget getReactiveForm(
      {required BuildContext context,
      required String field,
      required FormGroup baseForm,
      Widget? child}) {
    FormGroup childFormGroup = baseForm.controls[field] as FormGroup;
    return ReactiveForm(
      formGroup: childFormGroup,
      child: child ??
          Column(
            children: getMainFieldsForForms(context: context)
                .map((e) => getFormMainControllerWidgetReactive(
                    context: context, field: e, baseForm: childFormGroup))
                .toList(),
          ),
    );
  }

  List<DropdownMenuItem> getDropDownMenu(
      BuildContext context, ViewAbstractEnum e) {
    return e
        .getValues()
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: ListTile(
              leading: Icon((e as ViewAbstractEnum).getMainIconData()),
              title: Text(e.getFieldLabelString(context, e)),
            ),
          ),
        )
        .toList();
  }

  ViewAbstract getValueIfListMultiChipApi(String field) {
    throw Exception(
        "you should implement getValueIfListMultiChipApi for  $T field:$field");
  }

  Widget getFormMainControllerWidgetReactive({
    required BuildContext context,
    required String field,
    required FormGroup baseForm,
    ViewAbstract? parent,
  }) {
    FormOptions options = getFormOptionsReactive(context, field);
    Widget widget;
    debugPrint(
        "getFormMainControllerWidgetReactive parent=> ${getTableNameApi()} field=> $field ");
    bool shouldWrapWithTile = true;
    if (field == 'iD') {
      return Visibility(
        visible: false,
        child: getFormFieldTextReactive(
            context: context,
            field: field,
            options: options,
            readOnly: true,
            baseForm: baseForm),
      );
    }

    if (options.value is ViewAbstractEnum) {
      widget = getReactiveFormDropbox(
          context: context, baseForm: baseForm, field: field, options: options);
    } else if (options.value is ViewAbstract) {
      debugPrint(
          "getFormMainControllerWidgetReactive isViewAbstract $field ${getTableNameApi()}");
      widget = (options.value as ViewAbstract).getReactiveViewAbstractField(
          context: context, baseForm: baseForm, field: field, options: options);
    } else {
      FormFieldControllerType textFieldTypeVA = this.getInputType(field);
      if (textFieldTypeVA == FormFieldControllerType.DATE_TIME) {
        widget = getFormFieldDateTimeReactive(
            context: context,
            field: field,
            options: options,
            baseForm: baseForm);
      } else if (textFieldTypeVA == FormFieldControllerType.CHECKBOX) {
        shouldWrapWithTile = false;
        widget = getFormFieldCheckboxReactive(
            context: context,
            field: field,
            options: options,
            baseForm: baseForm);
      } else if (textFieldTypeVA == FormFieldControllerType.EDIT_TEXT) {
        widget = getFormFieldTextReactive(
            context: context,
            field: field,
            options: options,
            baseForm: baseForm);
      } else if (textFieldTypeVA == FormFieldControllerType.IMAGE) {
        widget = const Text("IMAGE");
      } else if (textFieldTypeVA == FormFieldControllerType.COLOR_PICKER) {
        widget = getFormFieldColorPickerReactive(
            context: context,
            field: field,
            options: options,
            baseForm: baseForm);
      } else if (textFieldTypeVA == FormFieldControllerType.FILE_PICKER) {
        widget = const Text("FILE");
      } else if (textFieldTypeVA == FormFieldControllerType.MULTI_CHIPS_API) {
        widget = getFormFieldMultiChipReactive(
            context: context,
            field: field,
            options: options,
            baseForm: baseForm);
      } else if (textFieldTypeVA == FormFieldControllerType.AUTO_COMPLETE) {
        widget = getFormFieldAutoCompleteReactive(
            context: context,
            field: field,
            baseForm: baseForm,
            options: options);
      } else if (textFieldTypeVA ==
          FormFieldControllerType.AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE) {
        widget = getFormFieldAutoCompleteViewAbstractResponseReactive(
            context: context,
            field: field,
            options: options,
            baseForm: baseForm);

        // widget = Text("TODFO");
      } else {
        widget = const Text("OTHER");
      }
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
      //TODO could be ChoiceChip or Dropdown
    } else if (options.value is ViewAbstract) {
      // widget = Text("DSa");
      widget = NestedFormBuilder(
        name: field,
        parentFormKey: formKey,
        child: getFormFieldAutoCompleteViewAbstractResponse(
            context: context, field: field, options: options),
      );
    } else {
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
            context: context,
            field: field,
            parentForm: formKey,
            options: options);
      } else if (textFieldTypeVA ==
          FormFieldControllerType.AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE) {
        widget = getFormFieldAutoCompleteViewAbstractResponse(
            context: context, field: field, options: options);
      } else {
        widget = const Text("OTHER");
      }
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
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hint,
    String? label,
    IconData? icon,
  }) {
    return InputDecoration(
        icon: icon == null ? null : Icon(icon),
        hintText: hint,
        // border: InputBorder.none,
        // errorStyle: Theme.of(context)
        //     .textTheme
        //     .bodySmall
        //     ?.copyWith(color: Theme.of(context).colorScheme.error),
        labelText: label,
        counterText: '',
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixText: prefix,
        suffixText: suffix);
  }

  InputDecoration getDecorationCheckBox() {
    return const InputDecoration(filled: false, border: InputBorder.none);
  }

  InputDecoration getDecorationDropdown(
      BuildContext context, ViewAbstractEnum enumAbstract) {
    return getDecorationIconHintPrefix(
        context: context,
        hint: enumAbstract.getMainLabelText(
          context,
        ),
        label: enumAbstract.getMainLabelText(
          context,
        ),
        icon: enumAbstract.getMainIconData());
  }

  InputDecoration getDecoration(BuildContext context, ViewAbstract viewAbstract,
      {String? field,
      bool requireIcon = true,
      Widget? suffixIcon,
      Widget? prefixIcon}) {
    bool isLarge = isLargeScreen(context);
    if (field != null) {
      return getDecorationIconHintPrefix(
          context: context,
          prefix: viewAbstract.getTextInputPrefix(context, field),
          suffix: viewAbstract.getTextInputSuffix(context, field),
          hint: viewAbstract.getTextInputHint(context, field: field),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
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
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
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
  COLOR_PICKER,
  FILE_PICKER,
  CHECKBOX,

  AUTO_COMPLETE,
  AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE,

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
