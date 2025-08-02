// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customs_declarations_images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomsDeclarationImages _$CustomsDeclarationImagesFromJson(
  Map<String, dynamic> json,
) =>
    CustomsDeclarationImages()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..image = json['image'] as String?
      ..comments = json['comments'] as String?
      ..customs_declarations =
          json['customs_declarations'] == null
              ? null
              : CustomsDeclaration.fromJson(
                json['customs_declarations'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$CustomsDeclarationImagesToJson(
  CustomsDeclarationImages instance,
) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'image': instance.image,
  'comments': instance.comments,
  'customs_declarations': instance.customs_declarations?.toJson(),
};
