// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_names.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountName _$AccountNameFromJson(Map<String, dynamic> json) =>
    AccountName()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..name = intFromString(json['name'])
      ..account_names_types =
          json['account_names_types'] == null
              ? null
              : AccountNameType.fromJson(
                json['account_names_types'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$AccountNameToJson(AccountName instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
      'account_names_types': instance.account_names_types?.toJson(),
    };

AccountNameType _$AccountNameTypeFromJson(Map<String, dynamic> json) =>
    AccountNameType()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..type = json['type'] as String?
      ..typeAr = json['typeAr'] as String?
      ..account_names =
          (json['account_names'] as List<dynamic>?)
              ?.map((e) => AccountName.fromJson(e as Map<String, dynamic>))
              .toList()
      ..account_names_count = (json['account_names_count'] as num?)?.toInt();

Map<String, dynamic> _$AccountNameTypeToJson(AccountNameType instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'type': instance.type,
      'typeAr': instance.typeAr,
      'account_names': instance.account_names?.map((e) => e.toJson()).toList(),
      'account_names_count': instance.account_names_count,
    };
