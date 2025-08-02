// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_action_abstract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionActionAbstract _$PermissionActionAbstractFromJson(
  Map<String, dynamic> json,
) =>
    PermissionActionAbstract()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..table_name = json['table_name'] as String?
      ..print = (json['print'] as num?)?.toInt()
      ..notification = (json['notification'] as num?)?.toInt()
      ..list = (json['list'] as num?)?.toInt()
      ..view = (json['view'] as num?)?.toInt()
      ..add = (json['add'] as num?)?.toInt()
      ..edit = (json['edit'] as num?)?.toInt()
      ..delete_action = (json['delete_action'] as num?)?.toInt();

Map<String, dynamic> _$PermissionActionAbstractToJson(
  PermissionActionAbstract instance,
) => <String, dynamic>{
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
