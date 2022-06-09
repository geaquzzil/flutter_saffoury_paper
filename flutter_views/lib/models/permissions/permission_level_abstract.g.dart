// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_level_abstract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionLevelAbstract<T>
    _$PermissionLevelAbstractFromJson<T extends PermissionActionAbstract>(
        Map<String, dynamic> json) {
  return PermissionLevelAbstract<T>()
    ..iD = json['iD'] as String
    ..userlevelname = json['userlevelname'] as String?
    ..permissions_levels = (json['permissions_levels'] as List<dynamic>?)
        ?.map(
            (e) => PermissionActionAbstract.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic>
    _$PermissionLevelAbstractToJson<T extends PermissionActionAbstract>(
            PermissionLevelAbstract<T> instance) =>
        <String, dynamic>{
          'iD': instance.iD,
          'userlevelname': instance.userlevelname,
          'permissions_levels':
              instance.permissions_levels?.map((e) => e.toJson()).toList(),
        };
