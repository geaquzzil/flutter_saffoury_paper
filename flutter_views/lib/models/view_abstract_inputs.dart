import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';

abstract class ViewAbstractInputAndValidater<T>
    extends ViewAbstractController<T> {
  TextInputType? getTextInputType(String? field) {
    return null;
  }

  String? getTextInputPrefix(BuildContext context, String? field) {
    return null;
  }

  String? getTextInputSuffix(BuildContext context, String? field) {
    return null;
  }

  Icon? getTextInputTypeIcon(String? field) {
    return Icon(getTextInputTypeIconData(field));
  }

  IconData? getTextInputTypeIconData(String? field) {
    return null;
  }

  String? getTextInputTypeHint(BuildContext context, String? field) {
    return null;
  }

  String? getTextInputTypeLabel(BuildContext context, String? field) {
    return getFieldLabel(field ?? "", context);
  }

  bool isFieldRequired(String? field) {
    return false;
  }

  bool isFieldCanBeNullable(BuildContext context, String? field) {
    return false;
  }

  String? getTextInputValidator(
      BuildContext context, String? field, String? value) {
    if (isFieldRequired(field) && (value?.isEmpty ?? false)) {
      return 'Name is required.';
    }
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }
}
