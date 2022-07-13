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
    userlevelname = "-";
    permissions_levels = List.empty();
  }

  static bool containsStaticKey(String key) {
    return hashMapOfPermissionTableAction.containsKey(key);
  }

  static PermissionActionAbstract? containsStaticKeyReturnValue(String key) {
    return hashMapOfPermissionTableAction[key];
  }

  @override
  Future<PermissionActionAbstract?> findPermissionBy(dynamic toDo) async {
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
    return PermissionLevelAbstract.fromJson(json);
  }

  @override
  List<String> getMainFields() {
    return ['userlevelname', 'permissions_levels'];
  }

  @override
  IconData getMainIconData() {
    return Icons.security;
  }

  @override
  String? getTableNameApi() {
    return "";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainLabelSubtitleTextOnly(BuildContext context) {
    // TODO: implement getMainLabelSubtitleTextOnly
    throw UnimplementedError();
  }

  @override
  Map<String, String> getTextInputHintMap(BuildContext context) {
    // TODO: implement getTextInputHintMap
    throw UnimplementedError();
  }

  @override
  Map<String, IconData> getTextInputIconMap() {
    // TODO: implement getTextInputIconMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() {
    // TODO: implement getTextInputIsAutoCompleteMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getTextInputLabelMap(BuildContext context) {
    // TODO: implement getTextInputLabelMap
    throw UnimplementedError();
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() {
    // TODO: implement getTextInputMaxLengthMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    // TODO: implement getTextInputMaxValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    // TODO: implement getTextInputMinValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() {
    // TODO: implement getTextInputTypeMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() {
    // TODO: implement isFieldCanBeNullableMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldRequiredMap() {
    // TODO: implement isFieldRequiredMap
    throw UnimplementedError();
  }
}
