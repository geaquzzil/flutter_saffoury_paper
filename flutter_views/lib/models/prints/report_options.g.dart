// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportOptions _$ReportOptionsFromJson(Map<String, dynamic> json) =>
    ReportOptions()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..reportHeader = json['reportHeader'] as String?
      ..reportFooter = json['reportFooter'] as String?;

Map<String, dynamic> _$ReportOptionsToJson(ReportOptions instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'reportHeader': instance.reportHeader,
      'reportFooter': instance.reportFooter,
    };
