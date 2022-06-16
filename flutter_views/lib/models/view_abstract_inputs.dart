import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_generater.dart';

abstract class ViewAbstractInputAndValidater<T>
    extends ViewAbstractController<T> {
  TextInputType? getTextInputType(String? field) {
    return null;
  }

  String? getTextInputPrefix(String? field) {
    return null;
  }

  String? getTextInputSuffix(String? field) {
    return null;
  }

  Icon? getTextInputTypeIcon(String? field) {
    return Icon(getTextInputTypeIconData(field));
  }

  IconData? getTextInputTypeIconData(String? field) {
    return null;
  }

  String? getTextInputTypeHint(String? field) {
    return null;
  }
}
