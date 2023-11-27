// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customs_declarations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomsDeclaration _$CustomsDeclarationFromJson(Map<String, dynamic> json) =>
    CustomsDeclaration()
      ..iD = json['iD'] as int
      ..number = CustomsDeclaration.intFromString(json['number'])
      ..date = json['date'] as String?
      ..fromCountry = json['fromCountry'] as String?
      ..fromName = json['fromName'] as String?
      ..comments = json['comments'] as String?
      ..customs_declarations_images =
          (json['customs_declarations_images'] as List<dynamic>?)
              ?.map((e) =>
                  CustomsDeclarationImages.fromJson(e as Map<String, dynamic>))
              .toList()
      ..customs_declarations_images_count =
          json['customs_declarations_images_count'] as int?
      ..employees = json['employees'] == null
          ? null
          : Employee.fromJson(json['employees'] as Map<String, dynamic>);

Map<String, dynamic> _$CustomsDeclarationToJson(CustomsDeclaration instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'number': instance.number,
      'date': instance.date,
      'fromCountry': instance.fromCountry,
      'fromName': instance.fromName,
      'comments': instance.comments,
      'customs_declarations_images':
          instance.customs_declarations_images?.map((e) => e.toJson()).toList(),
      'customs_declarations_images_count':
          instance.customs_declarations_images_count,
      'employees': instance.employees?.toJson(),
    };
