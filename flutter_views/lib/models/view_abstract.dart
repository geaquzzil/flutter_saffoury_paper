import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

abstract class ViewAbstract<T> extends ViewAbstractFilterable<T> {
  ViewAbstract() : super();

  List<Widget> getHorizotalList(BuildContext context) => [];

  bool isEqualsAsType(ViewAbstract? object) {
    if (object == null) {
      return false;
    }
    debugPrint(
        "isEqualsAsType type is $runtimeType object type is ${object.runtimeType}");
    return runtimeType == object.runtimeType;
  }

  bool isEquals(ViewAbstract? object) {
    if (object == null) {
      return false;
    }
    return object.iD == iD && object.getTableNameApi() == getTableNameApi();
  }

  T copyWithNewSuggestion(ViewAbstract newValue) {
    newValue.setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    newValue.setFieldNameFromParent(fieldNameFromParent);
    newValue.setParent(parent);
    return newValue as T;
  }

  T copyWithSetNew(String field, dynamic value) {
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    jsonCopy[field] = castFieldValue(field, value);
    jsonCopy['iD'] = -1;
    T newObject = fromJsonViewAbstract(jsonCopy);

    (newObject as ViewAbstract).setFieldNameFromParent(fieldNameFromParent);
    (newObject as ViewAbstract).setParent(parent);
    (newObject).setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    return newObject;
  }

  T copyWith(Map<String, dynamic> map) {
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    jsonCopy.forEach((key, value) {
      if (map.containsKey(key)) {
        jsonCopy[key] = castFieldValue(key, map[key]);
      }
    });
    T newObject = fromJsonViewAbstract(jsonCopy);

    ((newObject as ViewAbstract)).setFieldNameFromParent(fieldNameFromParent);
    (newObject as ViewAbstract).setParent(parent);
    (newObject).setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    (newObject).textFieldController = textFieldController;
    return newObject;
  }

  @override
  String toString() {
    return toJsonString();
  }

  String getActionText(BuildContext context) {
    if (isEditing()) {
      return "${AppLocalizations.of(context)!.edit} ${getMainHeaderLabelTextOnly(context)}";
    }
    return "${AppLocalizations.of(context)!.add_new} ${getMainHeaderLabelTextOnly(context)}";
  }
}

class ListableDataRow {
  String fieldName;
  String labelTitle;
  ListableDataRow(this.fieldName, this.labelTitle);
}
