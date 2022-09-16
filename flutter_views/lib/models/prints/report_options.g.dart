// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportOptions _$ReportOptionsFromJson(Map<String, dynamic> json) {
  return ReportOptions()
    ..iD = json['iD'] as int
    ..reportHeader = json['reportHeader'] as String?
    ..reportFooter = json['reportFooter'] as String?;
}

Map<String, dynamic> _$ReportOptionsToJson(ReportOptions instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'reportHeader': instance.reportHeader,
      'reportFooter': instance.reportFooter,
    };
