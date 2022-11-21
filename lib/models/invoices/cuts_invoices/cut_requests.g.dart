// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cut_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CutRequest _$CutRequestFromJson(Map<String, dynamic> json) => CutRequest()
  ..iD = json['iD'] as int
  ..searchByAutoCompleteTextInput =
      json['searchByAutoCompleteTextInput'] as String?
  ..delete = json['delete'] as bool?
  ..date = json['date'] as String?
  ..comments = json['comments'] as String?
  ..quantity = (json['quantity'] as num?)?.toDouble()
  ..cut_status = $enumDecodeNullable(_$CutStatusEnumMap, json['cut_status'])
  ..products = json['products'] == null
      ? null
      : Product.fromJson(json['products'] as Map<String, dynamic>)
  ..customers = json['customers'] == null
      ? null
      : Customer.fromJson(json['customers'] as Map<String, dynamic>)
  ..employees = json['employees'] == null
      ? null
      : Employee.fromJson(json['employees'] as Map<String, dynamic>)
  ..cut_request_results = (json['cut_request_results'] as List<dynamic>?)
      ?.map((e) => CutRequestResult.fromJson(e as Map<String, dynamic>))
      .toList()
  ..cut_request_results_count = json['cut_request_results_count'] as int?
  ..sizes_cut_requests = (json['sizes_cut_requests'] as List<dynamic>?)
      ?.map((e) => SizesCutRequest.fromJson(e as Map<String, dynamic>))
      .toList()
  ..sizes_cut_requests_count = json['sizes_cut_requests_count'] as int?;

Map<String, dynamic> _$CutRequestToJson(CutRequest instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'searchByAutoCompleteTextInput': instance.searchByAutoCompleteTextInput,
      'delete': instance.delete,
      'date': instance.date,
      'comments': instance.comments,
      'quantity': instance.quantity,
      'cut_status': _$CutStatusEnumMap[instance.cut_status],
      'products': instance.products?.toJson(),
      'customers': instance.customers?.toJson(),
      'employees': instance.employees?.toJson(),
      'cut_request_results':
          instance.cut_request_results?.map((e) => e.toJson()).toList(),
      'cut_request_results_count': instance.cut_request_results_count,
      'sizes_cut_requests':
          instance.sizes_cut_requests?.map((e) => e.toJson()).toList(),
      'sizes_cut_requests_count': instance.sizes_cut_requests_count,
    };

const _$CutStatusEnumMap = {
  CutStatus.PENDING: 'PENDING',
  CutStatus.PROCESSING: 'PROCESSING',
  CutStatus.COMPLETED: 'COMPLETED',
};
