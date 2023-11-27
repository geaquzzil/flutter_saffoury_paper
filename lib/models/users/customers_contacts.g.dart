// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_contacts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerContacts _$CustomerContactsFromJson(Map<String, dynamic> json) =>
    CustomerContacts()
      ..iD = json['iD'] as int
      ..customers = json['customers'] == null
          ? null
          : Customer.fromJson(json['customers'] as Map<String, dynamic>)
      ..name = json['name'] as String?
      ..phone = json['phone'] as String?;

Map<String, dynamic> _$CustomerContactsToJson(CustomerContacts instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'customers': instance.customers?.toJson(),
      'name': instance.name,
      'phone': instance.phone,
    };
