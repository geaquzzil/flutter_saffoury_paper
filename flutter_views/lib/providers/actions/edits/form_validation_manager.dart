import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class FormValidationManager2 {
  final _fieldStates = <String, dynamic>{};

  void setError(ViewAbstract viewAbstract, String key, bool isValidate) {
    dynamic map = _fieldStates[viewAbstract.getTagWithFirstParent()];
    if (map is Map<String, dynamic>) {
      map[key] = isValidate;
    }
  }

  bool hasError(ViewAbstract viewAbstract) {
    dynamic map = _fieldStates[viewAbstract.getTagWithFirstParent()];
    if (map is Map<String, dynamic>) {
      return map.entries.where((e) => e.value == false).isNotEmpty;
    }
    return false;
  }

  void notifyField(GlobalKey<FormBuilderState> formKey, String key,
      ViewAbstract v, String field) {
    bool? result = formKey.currentState?.fields[key]?.validate();
    debugPrint(
        "FormValidationManager2 notifyField field =>$field res=>$result");
    if (v.getParnet == null) {
      _fieldStates[field] = (result) ?? true;
    } else {
      setError(v, field, result ?? true);
    }
  }

  bool hasErrorField(ViewAbstract viewAbstract, String field) {
    debugPrint("FormValidationManager2 hasErrorField field =>$field");
    if (viewAbstract.getParnet == null) {
      dynamic b = _fieldStates[field];
      return b == null ? false : b as bool;
    } else {
      dynamic map = _fieldStates[viewAbstract.getTagWithFirstParent()];
      dynamic b = map[field];
      return b == null ? false : b as bool;
    }
  }

  void removeError(ViewAbstract viewAbstract) {
    dynamic map = _fieldStates[viewAbstract.getTagWithFirstParent()];
    if (map is Map<String, dynamic>) {
      map.values.map((e) => {e.value = true});
    }
  }

  void addField(String field, dynamic value) {
    if (value is ViewAbstract) {
      _fieldStates[value.getTagWithFirstParent()] = getMap(field, value);
    } else {
      _fieldStates[field] = true;
    }

    debugPrint("FormValidationManager2 last _fieldStates $_fieldStates");
  }

  Map<String, dynamic> getMap(String field, ViewAbstract value,
      {Map<String, dynamic>? map}) {
    String key = value.getTagWithFirstParent();
    Map<String, dynamic> viewAbstractMap = <String, dynamic>{};

    if (_fieldStates.containsKey(key)) {
      viewAbstractMap = _fieldStates[key];
    }
    viewAbstractMap[field] = true;
    return viewAbstractMap;
  }
}
