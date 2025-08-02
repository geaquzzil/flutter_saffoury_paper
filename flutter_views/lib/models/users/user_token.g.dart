// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserToken _$UserTokenFromJson(Map<String, dynamic> json) =>
    UserToken()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..token = json['token'] as String?;

Map<String, dynamic> _$UserTokenToJson(UserToken instance) => <String, dynamic>{
  'iD': instance.iD,
  'token': instance.token,
};
