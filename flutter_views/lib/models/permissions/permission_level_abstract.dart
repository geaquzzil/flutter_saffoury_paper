import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/permission_action_abstract.dart';
import 'package:collection/collection.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';
import '../view_abstract.dart';

part 'permission_level_abstract.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PermissionLevelAbstract extends ViewAbstract<PermissionLevelAbstract> {
  String? userlevelname;

  static Map<String, PermissionActionAbstract> hashMapOfPermissionTableAction =
      {};

  List<PermissionActionAbstract> permissions_levels = [];
  PermissionLevelAbstract() : super() {
    userlevelname = '-';
    permissions_levels = List.empty();
  }

  static bool containsStaticKey(String key) {
    return hashMapOfPermissionTableAction.containsKey(key);
  }

  static PermissionActionAbstract? containsStaticKeyReturnValue(String key) {
    return hashMapOfPermissionTableAction[key];
  }

  Future<PermissionActionAbstract?> findCurrentPermission(dynamic toDo) async {
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

    foundedPermission = permissions_levels.firstWhereOrNull((o) =>
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


  factory PermissionLevelAbstract.fromJson(Map<String, dynamic> data) =>
      _$PermissionLevelAbstractFromJson(data);

  Map<String, dynamic> toJson() => _$PermissionLevelAbstractToJson(this);

  @override
  PermissionLevelAbstract fromJsonViewAbstract(Map<String, dynamic> json) {
    return PermissionLevelAbstract.fromJson(json) as PermissionLevelAbstract;
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
  IconData getIconData() {
    return Icons.security;
  }

  @override
  IconData getFieldIconData(String label) {
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
