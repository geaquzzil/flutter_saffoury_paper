import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class ViewAbstract<T> extends ViewAbstractFilterable<T> {
  bool? delete;
  @JsonKey(ignore: true)
  bool? selected;
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

  T getNewInstance({String? searchByAutoCompleteTextInput}) {
    T ob = ((copyWithNewSuggestion(this) as ViewAbstract)..iD = -1) as T;
    (ob as ViewAbstract).searchByAutoCompleteTextInput =
        searchByAutoCompleteTextInput;
    return ob;
  }

  T? onAfterValidate(BuildContext context) {
    return this as T;
  }

  /// return default constructor value
  T copyWithSetNewFileReader() {
    return this as T;
  }

  T copyWithSetNew(String field, dynamic value) {
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    jsonCopy[field] = castFieldValue(field, value);
    jsonCopy['iD'] = -1;
    T newObject = fromJsonViewAbstract(jsonCopy);

    (newObject as ViewAbstract).setFieldNameFromParent(fieldNameFromParent);
    (newObject).setParent(parent);
    (newObject).setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    return newObject;
  }

  ///only get iD
  T copyWithReduceSize() {
    Map<String, dynamic> jsonCopy = {"iD": iD};
    return fromJsonViewAbstract(jsonCopy);
  }

  T copyToUplode() {
    if (this is ListableInterface) {
      Iterable<ViewAbstract>? l = (this as ListableInterface).deletedList;
      if (l != null) {
        debugPrint("copyToUplode list to delete=> $l");
        (this as ListableInterface).getListableList().addAll(l);
      }
    }
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    jsonCopy.forEach((key, value) {
      dynamic o = getFieldValue(key);
      if (o is ViewAbstract) {
        debugPrint("copyToUplode field=$key isViewAbstract ");
        if (o.isNull) {
          debugPrint("copyToUplode field=$key is Null ");
          jsonCopy[key] = null;
        }
      } else if (o == null) {
        jsonCopy[key] = null;
      } else if (o == "null") {
        jsonCopy[key] = null;
      } else if (o == "") {
        jsonCopy[key] = null;
      }
    });

    return fromJsonViewAbstract(jsonCopy);
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
    (newObject).setParent(parent);
    (newObject).setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    (newObject).textFieldController = textFieldController;
    return newObject;
  }

  @override
  String toString() {
    return toJsonString();
  }

  String toStringValues() {
    return toJsonViewAbstract().values.toString();
  }

  String getActionText(BuildContext context) {
    if (isEditing()) {
      return "${AppLocalizations.of(context)!.edit} ${getMainHeaderLabelTextOnly(context)}";
    }
    return "${AppLocalizations.of(context)!.add_new} ${getMainHeaderLabelTextOnly(context)}";
  }

  List<Widget>? getCustomBottomWidget(BuildContext context, ServerActions action) {}

  List<Widget>? getCustomTopWidget(BuildContext context, ServerActions action) {}
}

class ListableDataRow {
  String fieldName;
  String labelTitle;
  ListableDataRow(this.fieldName, this.labelTitle);
}
