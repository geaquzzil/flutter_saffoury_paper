// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incomes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Incomes _$IncomesFromJson(Map<String, dynamic> json) =>
    Incomes()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..fromBox = (json['fromBox'] as num?)?.toInt()
      ..isDirect = (json['isDirect'] as num?)?.toInt()
      ..date = json['date'] as String?
      ..value = (json['value'] as num?)?.toDouble()
      ..comments = convertToStringFromString(json['comments'])
      ..customers =
          json['customers'] == null
              ? null
              : Customer.fromJson(json['customers'] as Map<String, dynamic>)
      ..employees =
          json['employees'] == null
              ? null
              : Employee.fromJson(json['employees'] as Map<String, dynamic>)
      ..equalities =
          json['equalities'] == null
              ? null
              : Equalities.fromJson(json['equalities'] as Map<String, dynamic>)
      ..warehouse =
          json['warehouse'] == null
              ? null
              : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>)
      ..account_names =
          json['account_names'] == null
              ? null
              : AccountName.fromJson(
                json['account_names'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$IncomesToJson(Incomes instance) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'fromBox': instance.fromBox,
  'isDirect': instance.isDirect,
  'date': instance.date,
  'value': instance.value,
  'comments': instance.comments,
  'customers': instance.customers?.toJson(),
  'employees': instance.employees?.toJson(),
  'equalities': instance.equalities?.toJson(),
  'warehouse': instance.warehouse?.toJson(),
  'account_names': instance.account_names?.toJson(),
};
