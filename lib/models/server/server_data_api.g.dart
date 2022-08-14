// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_data_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterableDataApi _$FilterableDataApiFromJson(Map<String, dynamic> json) =>
    FilterableDataApi()
      ..iD = json['iD'] as int
      ..product_types = (json['product_types'] as List<dynamic>)
          .map((e) => ProductType.fromJson(e as Map<String, dynamic>))
          .toList()
      ..qualities = (json['qualities'] as List<dynamic>)
          .map((e) => Quality.fromJson(e as Map<String, dynamic>))
          .toList()
      ..grades = (json['grades'] as List<dynamic>)
          .map((e) => Grades.fromJson(e as Map<String, dynamic>))
          .toList()
      ..customs_declarations = (json['customs_declarations'] as List<dynamic>)
          .map((e) => CustomsDeclaration.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$FilterableDataApiToJson(FilterableDataApi instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'product_types': instance.product_types.map((e) => e.toJson()).toList(),
      'qualities': instance.qualities.map((e) => e.toJson()).toList(),
      'grades': instance.grades.map((e) => e.toJson()).toList(),
      'customs_declarations':
          instance.customs_declarations.map((e) => e.toJson()).toList(),
    };
