import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';

abstract class ViewAbstract<T> extends ViewAbstractFilterable<T> {
  bool isEquals(ViewAbstract? object) {
    if (object == null) {
      return false;
    }
    return object.iD == iD && object.getTableNameApi() == getTableNameApi();
  }

  dynamic castFieldValue(String field, dynamic value) {
    Type fieldType = getFieldType(field);
    debugPrint("castFieldValue type is $fieldType");

    // value = value ?? "";
    if (fieldType == int) {
      return int.parse(value.toString());
    } else if (fieldType == num) {
      return num.parse(value.toString());
    } else if (fieldType == double) {
      return double.parse(value.toString());
    } else if (fieldType == String) {
      return value.toString();
    } else {
      return value;
    }
  }

  T copyWithNewSuggestion(ViewAbstract newValue) {
    newValue.setFieldNameFromParent(fieldNameFromParent);
    newValue.setParent(parent);
    return newValue as T;
  }

  T copyWithSetNew(String field, dynamic value) {
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    jsonCopy[field] = castFieldValue(field, value);
    jsonCopy['iD'] = -1;
    T newObject = fromJsonViewAbstract(jsonCopy);
    (newObject as ViewAbstract).setParent(parent);
    (newObject).setFieldNameFromParent(fieldNameFromParent);
    (newObject).setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    return newObject;
  }

  @override
  String toString() {
    return toJsonString();
  }
}
