// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changes_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangesRecordGroup _$ChangesRecordGroupFromJson(Map<String, dynamic> json) =>
    ChangesRecordGroup()
      ..count = (json['count'] as num?)?.toInt()
      ..groupBy = ChangesRecordGroup.convertToString(json['groupBy'])
      ..total = ChangesRecordGroup.convertToDouble(json['total']);

Map<String, dynamic> _$ChangesRecordGroupToJson(ChangesRecordGroup instance) =>
    <String, dynamic>{
      'count': instance.count,
      'groupBy': instance.groupBy,
      'total': instance.total,
    };
