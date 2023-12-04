// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sizes_cut_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SizesCutRequest _$SizesCutRequestFromJson(Map<String, dynamic> json) =>
    SizesCutRequest()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..cut_requests = json['cut_requests'] == null
          ? null
          : CutRequest.fromJson(json['cut_requests'] as Map<String, dynamic>)
      ..sizes = json['sizes'] == null
          ? null
          : ProductSize.fromJson(json['sizes'] as Map<String, dynamic>)
      ..quantity = (json['quantity'] as num?)?.toDouble();

Map<String, dynamic> _$SizesCutRequestToJson(SizesCutRequest instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'cut_requests': instance.cut_requests?.toJson(),
      'sizes': instance.sizes?.toJson(),
      'quantity': instance.quantity,
    };
