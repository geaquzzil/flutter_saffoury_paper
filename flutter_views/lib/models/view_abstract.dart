import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reactive_forms/src/models/models.dart';

abstract class ViewAbstract<T> extends ViewAbstractFilterable<T> {
  @JsonKey(includeToJson: true, includeFromJson: false)
  bool? delete;
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool? selected;
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool? _isScannedFromQrCode;

  ///When deleting items this could be true if successfully deleted
  ///or String of message if error is ocurated
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? serverStatus;

  ///this helps with the notification action to know if editing or new record
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? fb_edit;

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

  Icon? getFBIcon({SecoundPaneHelperWithParentValueNotifier? secPaneHelper}) {
    IconData? ic = getFBEditIconData();
    return ic == null
        ? null
        : Icon(
            ic,
          );
  }

  IconData? getFBEditIconData() {
    if (fb_edit == null) return null;
    if (fb_edit == "edit") {
      return Icons.edit;
    } else if (fb_edit == "new") {
      return Icons.abc;
    } else {
      return Icons.delete;
    }
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

  Map<String, dynamic> getCopyWithFormTextField(String? text) {
    return {'text': text};
  }

  Map<String, dynamic>? copyWithFormValues({Map<String, dynamic>? values}) {
    return null;
  }

  T getNewInstance({Map<String, dynamic>? values, String? text}) {
    T ob = ((copyWithNewSuggestion(this) as ViewAbstract)..iD = -1) as T;

    return (ob as ViewAbstract).fromJsonViewAbstract(text != null
        ? copyWithFormValues(values: getCopyWithFormTextField(text)) ?? {}
        : copyWithFormValues(values: values) ?? {'iD': -1});
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

    //todo i added this for notify filter and sort by sliver api master
    (newObject).setCustomMap(getCustomMap);

    return newObject;
  }

  Map<String, dynamic> toJsonViewAbstractForm(Map<String, dynamic>? map) {
    if (map == null) {
      return {};
    }
    String jsonString = jsonEncode(map);
    return jsonDecode(
      jsonString,
      reviver: (key, value) {
        if (value is num) {
          return value.toString(); // Convert number to string
        }
        if (value is double) {
          return value.toString();
        }
        if (value is int) {
          return value.toString();
        }

        return value;
      },
    );
  }

  T? copyWithFromForms(Map<String, dynamic>? map) {
    if (map == null) return null;
    debugPrint("copyWithFromForms $map");
    Map<String, dynamic> jsonCopy = toJsonViewAbstract();
    jsonCopy.forEach((key, value) {
      if (map.containsKey(key)) {
        if (isViewAbstract(key)) {
          ViewAbstract? v = (getMirrorNewInstance(key) as ViewAbstract?)
              ?.copyWithFromForms(map[key]);
          jsonCopy[key] = (v)?.toJsonViewAbstract();
        } else {
          jsonCopy[key] = castFieldValue(key, map[key]);
        }
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

  @override
  bool operator ==(Object other) {
    return other is ViewAbstract &&
        (this as ViewAbstract).toString() == other.toString() &&
        (this as ViewAbstract).toStringValues() == other.toStringValues();
  }

  @override
  int get hashCode => Object.hash(toString(), toStringValues());

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
      {ServerActions? action,
      ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked}) {
    return null;
  }

  List<Widget>? getCustomTopWidget(BuildContext context,
      {ServerActions? action,
      ValueNotifier<ViewAbstract?>? onHorizontalListItemClicked,
      ValueNotifier<SecondPaneHelper?>? onClick}) {
    return null;
  }

  getScrollKey(ServerActions action) {
    return "$action-${getTableNameApi()}-$iD";
  }
}

class ListableDataRow {
  String fieldName;
  String labelTitle;
  ListableDataRow(this.fieldName, this.labelTitle);
}
