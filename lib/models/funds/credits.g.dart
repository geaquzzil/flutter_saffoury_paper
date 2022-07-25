// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credits _$CreditsFromJson(Map<String, dynamic> json) => Credits()
  ..iD = json['iD'] as int
  ..fromBox = json['fromBox'] as int?
  ..isDirect = json['isDirect'] as int?
  ..date = json['date'] as String?
  ..value = (json['value'] as num?)?.toDouble()
  ..comments = json['comments'] as String?
  ..customers = json['customers'] == null
      ? null
      : Customer.fromJson(json['customers'] as Map<String, dynamic>)
  ..employees = json['employees'] == null
      ? null
      : Employee.fromJson(json['employees'] as Map<String, dynamic>)
  ..equalities = json['equalities'] == null
      ? null
      : Equalities.fromJson(json['equalities'] as Map<String, dynamic>)
  ..warehouse = json['warehouse'] == null
      ? null
      : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>);

Map<String, dynamic> _$CreditsToJson(Credits instance) => <String, dynamic>{
      'iD': instance.iD,
      'fromBox': instance.fromBox,
      'isDirect': instance.isDirect,
      'date': instance.date,
      'value': instance.value,
      'comments': instance.comments,
      'customers': instance.customers?.toJson(),
      'employees': instance.employees?.toJson(),
      'equalities': instance.equalities?.toJson(),
      'warehouse': instance.warehouse?.toJson(),
    };