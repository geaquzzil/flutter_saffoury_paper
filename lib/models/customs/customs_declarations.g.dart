// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customs_declarations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomsDeclaration _$CustomsDeclarationFromJson(Map<String, dynamic> json) =>
    CustomsDeclaration()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..number = intFromString(json['number'])
      ..date = json['date'] as String?
      ..fromCountry = json['fromCountry'] as String?
      ..fromName = json['fromName'] as String?
      ..comments = convertToStringFromString(json['comments'])
      ..customs_declarations_images =
          (json['customs_declarations_images'] as List<dynamic>?)
              ?.map(
                (e) => CustomsDeclarationImages.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList()
      ..customs_declarations_images_count =
          (json['customs_declarations_images_count'] as num?)?.toInt()
      ..employees =
          json['employees'] == null
              ? null
              : Employee.fromJson(json['employees'] as Map<String, dynamic>)
      ..deletedList =
          (json['deletedList'] as List<dynamic>?)
              ?.map(
                (e) => CustomsDeclarationImages.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();

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
      'deletedList': instance.deletedList?.map((e) => e.toJson()).toList(),
    };
