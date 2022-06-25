import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';

abstract class ViewAbstractInputAndValidater<T>
    extends ViewAbstractController<T> {
  TextInputType? getTextInputType(String field) {
    return getMap()[field];
  }

  Map<String, TextInputType?> getMap() {
    return {};
  }

  bool? getTextInputIsEnabled(String field) {
    //TODO Check permission
    return null;
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

  IconData? getTextInputIconData(String field) {
    return getFieldIconData(field);
  }

  int? getTextInputMaxLength(String field) {
    return null;
  }

  String? getTextInputHint(BuildContext context, String field) {
    return null;
  }

  String? getTextInputLabel(BuildContext context, String field) {
    return getFieldLabel(field, context);
  }

  bool isFieldRequired(String field) {
    return false;
  }

  bool isFieldCanBeNullable(BuildContext context, String field) {
    return false;
  }

  TextCapitalization getTextInputCapitalization(String field) {
    return TextCapitalization.none;
  }

  List<TextInputFormatter>? getTextInputFormatter(String field) {
    var textInputType = getTextInputType(field);
    if (textInputType == null) return null;
    if (textInputType == TextInputType.phone ||
        textInputType == TextInputType.number) {
      return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    } else {
      return null;
    }
  }

  int? getTextInputValidatorMaxValue(String field) {
    return null;
  }

  int? getTextInputValidatorMinValue(String field) {
    return null;
  }

  String? getTextInputValidator(
      BuildContext context, String field, String? value) {
    String fieldLabel = getFieldLabel(field, context);
    if (isFieldRequired(field)) {
      if (value?.isEmpty ?? false) {
        return "$fieldLabel is required";
      }
    }
    if (getTextInputValidatorMaxValue(field) != null) {
      if (value != null &&
          int.parse(value) > getTextInputValidatorMaxValue(field)!) {
        return "$fieldLabel must be less than or equal to ${getTextInputValidatorMaxValue(field)}";
      }
    }
    if (getTextInputValidatorMinValue(field) != null) {
      if (value != null &&
          int.parse(value) < getTextInputValidatorMinValue(field)!) {
        return "$fieldLabel must be greater than or equal to ${getTextInputValidatorMinValue(field)}";
      }
    }
    return null;
  }
}
