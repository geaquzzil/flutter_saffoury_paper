// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gsms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GSM _$GSMFromJson(Map<String, dynamic> json) =>
    GSM()
      ..iD = convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..gsm = (json['gsm'] as num?)?.toInt()
      ..products =
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList()
      ..products_count = (json['products_count'] as num?)?.toInt();

Map<String, dynamic> _$GSMToJson(GSM instance) => <String, dynamic>{
  'iD': instance.iD,
  'delete': instance.delete,
  'gsm': instance.gsm,
  'products': instance.products?.map((e) => e.toJson()).toList(),
  'products_count': instance.products_count,
};
