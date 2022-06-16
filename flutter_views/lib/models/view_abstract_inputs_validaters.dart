import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';

abstract class ViewAbstractInputAndValidater<T>
    extends ViewAbstractController<T> {
  TextInputType? getTextInputType(String field) {
    return null;
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

  String? getTextInputValidator(
      BuildContext context, String field, String? value) {
    if (isFieldRequired(field)) {
      if (value?.isEmpty ?? false) {
        return getFieldLabel(field, context) + " is required";
      }
    }
    // final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    // if (!nameExp.hasMatch(value!)) {
    //   return 'Please enter only alphabetical characters.';
    // }
    return null;
  }
}
