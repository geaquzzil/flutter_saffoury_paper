// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equalities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equalities _$EqualitiesFromJson(Map<String, dynamic> json) => Equalities()
  ..iD = json['iD'] as int
  ..searchByAutoCompleteTextInput =
      json['searchByAutoCompleteTextInput'] as String?
  ..delete = json['delete'] as bool?
  ..value = (json['value'] as num?)?.toDouble()
  ..date = json['date'] as String?
  ..currency = json['currency'] == null
      ? null
      : Currency.fromJson(json['currency'] as Map<String, dynamic>);

Map<String, dynamic> _$EqualitiesToJson(Equalities instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'searchByAutoCompleteTextInput': instance.searchByAutoCompleteTextInput,
      'delete': instance.delete,
      'value': instance.value,
      'date': instance.date,
      'currency': instance.currency?.toJson(),
    };
