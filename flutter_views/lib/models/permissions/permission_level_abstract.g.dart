// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_level_abstract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionLevelAbstract _$PermissionLevelAbstractFromJson(
  Map<String, dynamic> json,
) =>
    PermissionLevelAbstract()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..userlevelname = json['userlevelname'] as String?
      ..permissions_levels =
          (json['permissions_levels'] as List<dynamic>?)
              ?.map(
                (e) => PermissionActionAbstract.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();

Map<String, dynamic> _$PermissionLevelAbstractToJson(
  PermissionLevelAbstract instance,
) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'userlevelname': instance.userlevelname,
  'permissions_levels':
      instance.permissions_levels?.map((e) => e.toJson()).toList(),
};
