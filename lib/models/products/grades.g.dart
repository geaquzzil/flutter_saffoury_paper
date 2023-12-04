// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grades.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grades _$GradesFromJson(Map<String, dynamic> json) => Grades()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..name = BaseWithNameString.intFromString(json['name'])
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products_count = json['products_count'] as int?;

Map<String, dynamic> _$GradesToJson(Grades instance) => <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'name': instance.name,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'products_count': instance.products_count,
    };
