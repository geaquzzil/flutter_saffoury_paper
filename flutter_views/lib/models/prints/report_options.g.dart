// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportOptions _$ReportOptionsFromJson(Map<String, dynamic> json) =>
    ReportOptions()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..reportHeader = json['reportHeader'] as String?
      ..reportFooter = json['reportFooter'] as String?;

Map<String, dynamic> _$ReportOptionsToJson(ReportOptions instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'reportHeader': instance.reportHeader,
      'reportFooter': instance.reportFooter,
    };
