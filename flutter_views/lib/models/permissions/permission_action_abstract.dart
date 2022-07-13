import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

import '../view_abstract.dart';

part 'permission_action_abstract.g.dart';

@JsonSerializable()
@reflector
class PermissionActionAbstract extends ViewAbstract<PermissionActionAbstract> {
  String? table_name;
  int? print;
  int? notification;
  int? list;
  int? view;
  int? add;
  int? edit;
  int? delete_action;

  PermissionActionAbstract() : super();

  factory PermissionActionAbstract.fromJson(Map<String, dynamic> data) =>
      _$PermissionActionAbstractFromJson(data);

  Map<String, dynamic> toJson() => _$PermissionActionAbstractToJson(this);

  @override
  PermissionActionAbstract fromJsonViewAbstract(Map<String, dynamic> data) {
    return PermissionActionAbstract.fromJson(data);
  }

  @override
  String? getTableNameApi() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  List<String> getMainFields() {
    return [
      "print",
      "notification",
      "list",
      "view",
      "add",
      "edit",
      "delete_action"
    ];
  }

  @override
  IconData getMainIconData() {
    return Icons.security;
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        'iD': Icons.numbers,
        "table_name": Icons.table_bar,
        "print": Icons.print,
        "notification": Icons.notifications,
        "list": Icons.list,
        "view": Icons.view_agenda,
        "add": Icons.add,
        "edit": Icons.edit,
        "delete_action": Icons.delete
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {};

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
