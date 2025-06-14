// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:collection/collection.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../view_abstract.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
part 'permission_level_abstract.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PermissionLevelAbstract extends ViewAbstract<PermissionLevelAbstract> {
  String? userlevelname;

  PermissionLevelAbstract() : super() {
    userlevelname = "-";
    permissions_levels = List.empty();
  }
  @override
  PermissionLevelAbstract getSelfNewInstance() {
    return PermissionLevelAbstract();
  }

  static Map<String, PermissionActionAbstract> hashMapOfPermissionTableAction =
      {};

  List<PermissionActionAbstract>? permissions_levels;

  static bool containsStaticKey(String key) {
    return hashMapOfPermissionTableAction.containsKey(key);
  }

  static PermissionActionAbstract? containsStaticKeyReturnValue(String key) {
    return hashMapOfPermissionTableAction[key];
  }

  PermissionActionAbstract? findPermissionBy(dynamic toDo) {
    PermissionActionAbstract? foundedPermission;
    String? currentTableNameFromObject = findCurrentTableNmeFromObject(toDo);
    if ((currentTableNameFromObject == null)) return null;
    if (containsStaticKey(currentTableNameFromObject)) {
      return containsStaticKeyReturnValue(currentTableNameFromObject);
    }
    // if (permissions_levels == null) return null;
    // await Future.forEach(permissions_levels,
    //     (PermissionActionAbstract element) {
    //   if (element.table_name != null &&
    //       element.table_name == currentTableNameFromObject) {
    //     foundedPermission = element;
    //     return;
    //   }
    // });

    foundedPermission = permissions_levels?.firstWhereOrNull((o) =>
        o.table_name != null && o.table_name == currentTableNameFromObject);
    if (foundedPermission != null) {
      hashMapOfPermissionTableAction[currentTableNameFromObject] =
          foundedPermission;
    }
    return foundedPermission;
  }

  String? getTableName(dynamic toDo) {
    if (toDo is! ViewAbstract) {
      return null;
    }
    ViewAbstract viewAbstract = toDo;
    return viewAbstract.getTableNameApi() ?? getCustomAction();
  }

  String? findCurrentTableNmeFromObject(dynamic toDo) {
    if (toDo is String) {
      return toDo.toString();
    } else {
      return getTableName(toDo);
    }
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    return ['userlevelname', 'permissions_levels'];
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.adminSetting;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return userlevelname ?? "";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.permissionName;
  }

  @override
  String? getTableNameApi() {
    return "";
  }

  @override
  IconData getMainIconData() {
    return Icons.security;
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "userlevelname": Icons.text_format,
      };

  @override
  Map<String, bool> isFieldRequiredMap() => {"userlevelname": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        'iD': TextInputType.text,
        "userlevelname": TextInputType.text,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() => {
        "userlevelname": 50,
      };

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        'iD': AppLocalizations.of(context)!.iD,
        "userlevelname": AppLocalizations.of(context)!.name,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() => {};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  factory PermissionLevelAbstract.fromJson(Map<String, dynamic> data) =>
      _$PermissionLevelAbstractFromJson(data);

  Map<String, dynamic> toJson() => _$PermissionLevelAbstractToJson(this);

  @override
  PermissionLevelAbstract fromJsonViewAbstract(Map<String, dynamic> json) {
    return PermissionLevelAbstract.fromJson(json);
  }

  @override
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "userlevelname", type: SortByType.ASC);

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {"userlevelname": ""};
}
