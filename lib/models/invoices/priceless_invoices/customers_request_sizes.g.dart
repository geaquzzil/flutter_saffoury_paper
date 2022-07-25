// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_request_sizes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerRequestSize _$CustomerRequestSizeFromJson(Map<String, dynamic> json) =>
    CustomerRequestSize()
      ..iD = json['iD'] as int
      ..TermsID = json['TermsID'] as int?
      ..date = json['date'] as String?
      ..billNo = json['billNo'] as String?
      ..comments = json['comments'] as String?
      ..employees = json['employees'] == null
          ? null
          : Employee.fromJson(json['employees'] as Map<String, dynamic>)
      ..customers = json['customers'] == null
          ? null
          : Customer.fromJson(json['customers'] as Map<String, dynamic>)
      ..cargo_transporters = json['cargo_transporters'] == null
          ? null
          : CargoTransporter.fromJson(
              json['cargo_transporters'] as Map<String, dynamic>)
      ..status = $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status'])
      ..customers_request_sizes_details =
          (json['customers_request_sizes_details'] as List<dynamic>?)
              ?.map((e) => CustomerRequestSizeDetails.fromJson(
                  e as Map<String, dynamic>))
              .toList()
      ..customers_request_sizes_details_count =
          json['customers_request_sizes_details_count'] as int?;

Map<String, dynamic> _$CustomerRequestSizeToJson(
        CustomerRequestSize instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'TermsID': instance.TermsID,
      'date': instance.date,
      'billNo': instance.billNo,
      'comments': instance.comments,
      'employees': instance.employees?.toJson(),
      'customers': instance.customers?.toJson(),
      'cargo_transporters': instance.cargo_transporters?.toJson(),
      'status': _$InvoiceStatusEnumMap[instance.status],
      'customers_request_sizes_details': instance
          .customers_request_sizes_details
          ?.map((e) => e.toJson())
          .toList(),
      'customers_request_sizes_details_count':
          instance.customers_request_sizes_details_count,
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.NONE: 'NONE',
  InvoiceStatus.PENDING: 'PENDING',
  InvoiceStatus.PROCESSING: 'PROCESSING',
  InvoiceStatus.CANCELED: 'CANCELED',
  InvoiceStatus.APPROVED: 'APPROVED',
};

CustomerRequestSizeDetails _$CustomerRequestSizeDetailsFromJson(
        Map<String, dynamic> json) =>
    CustomerRequestSizeDetails()
      ..iD = json['iD'] as int
      ..customers_request_sizes = json['customers_request_sizes'] == null
          ? null
          : CustomerRequestSize.fromJson(
              json['customers_request_sizes'] as Map<String, dynamic>)
      ..sizes = json['sizes'] == null
          ? null
          : Size.fromJson(json['sizes'] as Map<String, dynamic>)
      ..date = json['date'] as String?;

Map<String, dynamic> _$CustomerRequestSizeDetailsToJson(
        CustomerRequestSizeDetails instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'customers_request_sizes': instance.customers_request_sizes?.toJson(),
      'sizes': instance.sizes?.toJson(),
      'date': instance.date,
    };
