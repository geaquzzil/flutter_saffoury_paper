// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cut_request_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CutRequestResult _$CutRequestResultFromJson(Map<String, dynamic> json) =>
    CutRequestResult()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..cut_requests =
          json['cut_requests'] == null
              ? null
              : CutRequest.fromJson(
                json['cut_requests'] as Map<String, dynamic>,
              )
      ..products_inputs =
          json['products_inputs'] == null
              ? null
              : ProductInput.fromJson(
                json['products_inputs'] as Map<String, dynamic>,
              )
      ..products_outputs =
          json['products_outputs'] == null
              ? null
              : ProductOutput.fromJson(
                json['products_outputs'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$CutRequestResultToJson(CutRequestResult instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'cut_requests': instance.cut_requests?.toJson(),
      'products_inputs': instance.products_inputs?.toJson(),
      'products_outputs': instance.products_outputs?.toJson(),
    };
