// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cut_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CutRequest _$CutRequestFromJson(Map<String, dynamic> json) =>
    CutRequest()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..date = json['date'] as String?
      ..comments = ViewAbstractPermissions.convertToStringFromString(json['comments'])
      ..quantity = (json['quantity'] as num?)?.toDouble()
      ..cut_status = $enumDecodeNullable(_$CutStatusEnumMap, json['cut_status'])
      ..products =
          json['products'] == null
              ? null
              : Product.fromJson(json['products'] as Map<String, dynamic>)
      ..customers =
          json['customers'] == null
              ? null
              : Customer.fromJson(json['customers'] as Map<String, dynamic>)
      ..employees =
          json['employees'] == null
              ? null
              : Employee.fromJson(json['employees'] as Map<String, dynamic>)
      ..cut_request_results =
          (json['cut_request_results'] as List<dynamic>?)
              ?.map((e) => CutRequestResult.fromJson(e as Map<String, dynamic>))
              .toList()
      ..cut_request_results_count =
          (json['cut_request_results_count'] as num?)?.toInt()
      ..sizes_cut_requests =
          (json['sizes_cut_requests'] as List<dynamic>?)
              ?.map((e) => SizesCutRequest.fromJson(e as Map<String, dynamic>))
              .toList()
      ..sizes_cut_requests_count =
          (json['sizes_cut_requests_count'] as num?)?.toInt();

Map<String, dynamic> _$CutRequestToJson(CutRequest instance) =>
    <String, dynamic>{
      'iD': instance.iD,
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

ProfitByCutRequest _$ProfitByCutRequestFromJson(Map<String, dynamic> json) =>
    ProfitByCutRequest()
      ..cutRequestQuantity = convertToDouble(json['cutRequestQuantity'])
      ..inputQuantity = convertToDouble(json['inputQuantity'])
      ..resultQuantity = convertToDouble(json['resultQuantity'])
      ..totalPrice = convertToDouble(json['totalPrice'])
      ..CutRequestID = (json['CutRequestID'] as num?)?.toInt()
      ..date = json['date'] as String?;

Map<String, dynamic> _$ProfitByCutRequestToJson(ProfitByCutRequest instance) =>
    <String, dynamic>{
      'cutRequestQuantity': instance.cutRequestQuantity,
      'inputQuantity': instance.inputQuantity,
      'resultQuantity': instance.resultQuantity,
      'totalPrice': instance.totalPrice,
      'CutRequestID': instance.CutRequestID,
      'date': instance.date,
    };
