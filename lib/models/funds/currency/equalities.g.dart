// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equalities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equalities _$EqualitiesFromJson(Map<String, dynamic> json) => Equalities()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..value = (json['value'] as num?)?.toDouble()
  ..date = json['date'] as String?
  ..currency = json['currency'] == null
      ? null
      : Currency.fromJson(json['currency'] as Map<String, dynamic>);

Map<String, dynamic> _$EqualitiesToJson(Equalities instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'value': instance.value,
      'date': instance.date,
      'currency': instance.currency?.toJson(),
    };
