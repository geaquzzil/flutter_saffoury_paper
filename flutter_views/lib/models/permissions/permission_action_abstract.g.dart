// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_action_abstract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionActionAbstract _$PermissionActionAbstractFromJson(
        Map<String, dynamic> json) =>
    PermissionActionAbstract()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..table_name = json['table_name'] as String?
      ..print = json['print'] as int?
      ..notification = json['notification'] as int?
      ..list = json['list'] as int?
      ..view = json['view'] as int?
      ..add = json['add'] as int?
      ..edit = json['edit'] as int?
      ..delete_action = json['delete_action'] as int?;

Map<String, dynamic> _$PermissionActionAbstractToJson(
        PermissionActionAbstract instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'table_name': instance.table_name,
      'print': instance.print,
      'notification': instance.notification,
      'list': instance.list,
      'view': instance.view,
      'add': instance.add,
      'edit': instance.edit,
      'delete_action': instance.delete_action,
    };
