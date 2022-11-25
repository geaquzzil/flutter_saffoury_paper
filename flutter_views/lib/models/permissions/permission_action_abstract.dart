import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../view_abstract.dart';

part 'permission_action_abstract.g.dart';

@JsonSerializable(explicitToJson: true)
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

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.adminSetting;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return table_name ?? "";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.permission;
  }

  @override
  String? getTableNameApi() {
    throw UnimplementedError();
  }

  @override
  List<String> getMainFields() {
    return [
      "table_name",
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
  Map<String, bool> isFieldRequiredMap() => {"name": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        'iD': TextInputType.text,
        "table_name": TextInputType.text,
        "print": TextInputType.text,
        "notification": TextInputType.text,
        "list": TextInputType.text,
        "view": TextInputType.text,
        "add": TextInputType.text,
        "edit": TextInputType.text,
        "delete_action": TextInputType.text,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() => {
        "table_name": 50,
      };

  @override
  String? getImageUrl(BuildContext context) {
    return null;
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        'iD': AppLocalizations.of(context)!.iD,
        "table_name": AppLocalizations.of(context)!.name,
        "print": AppLocalizations.of(context)!.print,
        "notification": AppLocalizations.of(context)!.notification,
        "list": AppLocalizations.of(context)!.list,
        "view": AppLocalizations.of(context)!.view,
        "add": AppLocalizations.of(context)!.add,
        "edit": AppLocalizations.of(context)!.edit,
        "delete_action": AppLocalizations.of(context)!.delete
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

  factory PermissionActionAbstract.fromJson(Map<String, dynamic> data) =>
      _$PermissionActionAbstractFromJson(data);

  Map<String, dynamic> toJson() => _$PermissionActionAbstractToJson(this);

  @override
  PermissionActionAbstract fromJsonViewAbstract(Map<String, dynamic> data) {
    return PermissionActionAbstract.fromJson(data);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String getSortByFieldName() {
    return "table_name";
  }

  @override
  SortByType getSortByType() {
    return SortByType.DESC;
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "table_name": "",
        "print": 0,
        "notification": 0,
        "list": 0,
        "add": 0,
        "edit": 0,
        "view": 0,
        "delete_action": 0
      };

  @override
  PermissionActionAbstract getSelfNewInstance() {
    return  PermissionActionAbstract();
  }

  // @override
  // Map<String, Type> getMirrorFieldsTypeMap() => {
  //       "table_name": String,
  //       "print": int,
  //       "notification": int,
  //       "list": int,
  //       "add": int,
  //       "edit": int,
  //       "view": int,
  //       "delete_action": int
  //     };
}
