import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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

  TextInputType? getTextInputType(String field) {
    return getTextInputTypeMap()[field];
  }

  bool getTextInputTypeIsAutoComplete(String field) {
    return getTextInputIsAutoCompleteMap()[field] ?? false;
  }

  bool getTextInputTypeIsAutoCompleteViewAbstract(String field) {
    return getTextInputIsAutoCompleteViewAbstractMap()[field] ?? false;
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

  String? getTextInputHint(BuildContext context, String field) {
    String? label = getTextInputLabel(context, field);
    return "${AppLocalizations.of(context)!.enter} $label";
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

  String? getTextInputValidator(
      BuildContext context, String field, String? value) {
    String fieldLabel = getFieldLabel(context, field);
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    if (isFieldRequired(field)) {
      if (value?.isEmpty ?? false) {
        return "$fieldLabel is required";
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
}
