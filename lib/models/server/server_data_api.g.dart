// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_data_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterableDataApi _$FilterableDataApiFromJson(Map<String, dynamic> json) =>
    FilterableDataApi()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..products_types =
          (json['products_types'] as List<dynamic>?)
              ?.map((e) => ProductType.fromJson(e as Map<String, dynamic>))
              .toList()
      ..qualities =
          (json['qualities'] as List<dynamic>?)
              ?.map((e) => Quality.fromJson(e as Map<String, dynamic>))
              .toList()
      ..grades =
          (json['grades'] as List<dynamic>?)
              ?.map((e) => Grades.fromJson(e as Map<String, dynamic>))
              .toList()
      ..customs_declarations =
          (json['customs_declarations'] as List<dynamic>?)
              ?.map(
                (e) => CustomsDeclaration.fromJson(e as Map<String, dynamic>),
              )
              .toList()
      ..gsms =
          (json['gsms'] as List<dynamic>?)
              ?.map((e) => GSM.fromJson(e as Map<String, dynamic>))
              .toList()
      ..cargo_transporters =
          (json['cargo_transporters'] as List<dynamic>?)
              ?.map((e) => CargoTransporter.fromJson(e as Map<String, dynamic>))
              .toList()
      ..governorates =
          (json['governorates'] as List<dynamic>?)
              ?.map((e) => Governorate.fromJson(e as Map<String, dynamic>))
              .toList()
      ..account_names_types =
          (json['account_names_types'] as List<dynamic>?)
              ?.map((e) => AccountNameType.fromJson(e as Map<String, dynamic>))
              .toList()
      ..account_names =
          (json['account_names'] as List<dynamic>?)
              ?.map((e) => AccountName.fromJson(e as Map<String, dynamic>))
              .toList()
      ..currency =
          (json['currency'] as List<dynamic>?)
              ?.map((e) => Currency.fromJson(e as Map<String, dynamic>))
              .toList()
      ..customers =
          (json['customers'] as List<dynamic>?)
              ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
              .toList()
      ..employees =
          (json['employees'] as List<dynamic>?)
              ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
              .toList()
      ..warehouse =
          (json['warehouse'] as List<dynamic>?)
              ?.map((e) => Warehouse.fromJson(e as Map<String, dynamic>))
              .toList()
      ..countries =
          (json['countries'] as List<dynamic>?)
              ?.map((e) => Country.fromJson(e as Map<String, dynamic>))
              .toList()
      ..manufactures =
          (json['manufactures'] as List<dynamic>?)
              ?.map((e) => Manufacture.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$FilterableDataApiToJson(
  FilterableDataApi instance,
) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'products_types': instance.products_types?.map((e) => e.toJson()).toList(),
  'qualities': instance.qualities?.map((e) => e.toJson()).toList(),
  'grades': instance.grades?.map((e) => e.toJson()).toList(),
  'customs_declarations':
      instance.customs_declarations?.map((e) => e.toJson()).toList(),
  'gsms': instance.gsms?.map((e) => e.toJson()).toList(),
  'cargo_transporters':
      instance.cargo_transporters?.map((e) => e.toJson()).toList(),
  'governorates': instance.governorates?.map((e) => e.toJson()).toList(),
  'account_names_types':
      instance.account_names_types?.map((e) => e.toJson()).toList(),
  'account_names': instance.account_names?.map((e) => e.toJson()).toList(),
  'currency': instance.currency?.map((e) => e.toJson()).toList(),
  'customers': instance.customers?.map((e) => e.toJson()).toList(),
  'employees': instance.employees?.map((e) => e.toJson()).toList(),
  'warehouse': instance.warehouse?.map((e) => e.toJson()).toList(),
  'countries': instance.countries?.map((e) => e.toJson()).toList(),
  'manufactures': instance.manufactures?.map((e) => e.toJson()).toList(),
};
