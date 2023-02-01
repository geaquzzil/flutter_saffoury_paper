import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class ViewAbstract<T> extends ViewAbstractFilterable<T> {
  bool? delete;
  @JsonKey(ignore: true)
  bool? selected;
  @JsonKey(ignore: true)
  bool? _isScannedFromQrCode;

  ViewAbstract() : super();

  bool? get getIsScannedFromQrCode => _isScannedFromQrCode;

  set setIsScannedFromQrCode(bool? isScannedFromQrCode) =>
      _isScannedFromQrCode = isScannedFromQrCode;

  @Deprecated("could be replaced with getHomeListHeaderWidgetList")
  List<StaggeredGridTile>? getHomeListHeaderWidget(BuildContext context) =>
      null;
  List<Widget>? getHomeListHeaderWidgetList(BuildContext context) => null;
  List<StaggeredGridTile> getHomeHorizotalList(BuildContext context) => [];

  Widget? getHomeHeaderWidget(BuildContext context) {
    return null;
  }

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

  ///here we init fields to get from saved data or other...
  void onBeforeGenerateView(BuildContext context, {ServerActions? action}) {}

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

  ///this fires when the form key is not founded or the view is not generated yet
  T? onManuallyValidate(BuildContext context) {
    for (var element in getMainFields(context: context)) {
      dynamic value = getFieldValue(element);
      bool isError;
      if (isViewAbstract(element)) {
        if (value == null) {
          if (isFieldCanBeNullable(context, element)) {
            continue;
          } else {
            return null;
          }
        } else {
          if ((value as ViewAbstract).isEditing()) {
            debugPrint(
                "onManuallyValidate called subViewAbstract $T  field=>$element  skipped because subViewAbstract is editing mood");
            continue;
          }
          isError = (value).onManuallyValidate(context) == null;
          debugPrint(
              "onManuallyValidate called subViewAbstract $T  field=>$element  value => $value isError= $isError");
          if (isError) return null;
        }
      }

      isError =
          getTextInputValidatorCompose(context, element).call(value) != null;
      debugPrint(
          "onManuallyValidate called for $T  field=>$element  value => $value isError= $isError");
      if (isError) return null;
    }
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
    debugPrint("copyToUplode $jsonCopy");

    return fromJsonViewAbstract(jsonCopy);
  }

  T getCopyInstance() {
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    T newObject = fromJsonViewAbstract(jsonCopy);

    ((newObject as ViewAbstract)).setFieldNameFromParent(fieldNameFromParent);
    (newObject).setParent(parent);
    (newObject).setLastSearchViewAbstractByTextInputList(
        getLastSearchViewByTextInputList);
    (newObject).textFieldController = textFieldController;

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

  List<Widget>? getCustomBottomWidget(BuildContext context,
      {ServerActions? action}) {}

  List<Widget>? getCustomTopWidget(BuildContext context,
      {ServerActions? action}) {}
}

class ListableDataRow {
  String fieldName;
  String labelTitle;
  ListableDataRow(this.fieldName, this.labelTitle);
}
