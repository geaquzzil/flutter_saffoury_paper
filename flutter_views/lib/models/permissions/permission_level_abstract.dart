import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:collection/collection.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';
import '../view_abstract.dart';

part 'permission_level_abstract.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PermissionLevelAbstract<T extends PermissionActionAbstract>
    extends ViewAbstract<T> {
  String? userlevelname;

  static Map<String, PermissionActionAbstract> hashMapOfPermissionTableAction =
      {};

  List<PermissionActionAbstract>? permissions_levels;
  PermissionLevelAbstract() : super() {
    userlevelname = '-';
    permissions_levels = List<T>.empty();
  }

  static bool containsStaticKey(String key) {
    return hashMapOfPermissionTableAction.containsKey(key);
  }

  static PermissionActionAbstract? containsStaticKeyReturnValue(String key) {
    return hashMapOfPermissionTableAction[key];
  }

  PermissionActionAbstract? findCurrentPermission(dynamic toDo) {
    PermissionActionAbstract? foundedPermission;
    String? currentTableNameFromObject = findCurrentTableNmeFromObject(toDo);
    if ((currentTableNameFromObject == null)) return null;
    if (containsStaticKey(currentTableNameFromObject)) {
      return containsStaticKeyReturnValue(currentTableNameFromObject);
    }
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

  bool isAdmin() => false;

  bool isGuest() => false;

  bool isGeneralClient() => false;

  bool isGeneralEmployee() => false;

  factory PermissionLevelAbstract.fromJson(Map<String, dynamic> data) =>
      _$PermissionLevelAbstractFromJson(data);

  Map<String, dynamic> toJson() => _$PermissionLevelAbstractToJson(this);

  @override
  T fromJsonViewAbstract(Map<String, dynamic> json) {
    return PermissionLevelAbstract.fromJson(json) as T;
  }

  @override
  String getFieldLabel(String label, BuildContext context) {
    return label;
  }

  @override
  List<String> getFields() {
    return ['userlevelname', 'permissions_levels'];
  }

  @override
  IconData getIconData(BuildContext context) {
    return Icons.security;
  }

  @override
  IconData getIconDataField(String label, BuildContext context) {
    return Icons.security;
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    return "";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }
}
