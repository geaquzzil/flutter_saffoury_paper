// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dealer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dealers _$DealersFromJson(Map<String, dynamic> json) => Dealers()
  ..iD = json['iD'] as int?
  ..name = json['name'] as String?
  ..nameAr = json['nameAr'] as String?
  ..commNum = json['commNum'] as int?
  ..address = json['address'] as String?
  ..addressAr = json['addressAr'] as String?
  ..dealers_emails = (json['dealers_emails'] as List<dynamic>?)
      ?.map((e) => DealersEmails.fromJson(e as Map<String, dynamic>))
      .toList()
  ..dealers_emails_count = json['dealers_emails_count'] as int?
  ..dealers_phones = (json['dealers_phones'] as List<dynamic>?)
      ?.map((e) => DealersPhone.fromJson(e as Map<String, dynamic>))
      .toList()
  ..dealers_phones_count = json['dealers_phones_count'] as int?
  ..dealers_social = (json['dealers_social'] as List<dynamic>?)
      ?.map((e) => DealersSocial.fromJson(e as Map<String, dynamic>))
      .toList()
  ..dealers_social_count = json['dealers_social_count'] as int?;

Map<String, dynamic> _$DealersToJson(Dealers instance) => <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'commNum': instance.commNum,
      'address': instance.address,
      'addressAr': instance.addressAr,
      'dealers_emails':
          instance.dealers_emails?.map((e) => e.toJson()).toList(),
      'dealers_emails_count': instance.dealers_emails_count,
      'dealers_phones':
          instance.dealers_phones?.map((e) => e.toJson()).toList(),
      'dealers_phones_count': instance.dealers_phones_count,
      'dealers_social':
          instance.dealers_social?.map((e) => e.toJson()).toList(),
      'dealers_social_count': instance.dealers_social_count,
    };

DealersEmails _$DealersEmailsFromJson(Map<String, dynamic> json) =>
    DealersEmails()
      ..iD = json['iD'] as int?
      ..DealerID = json['DealerID'] as int?
      ..title = json['title'] as String?
      ..type = json['type'] as String?
      ..url = json['url'] as String?
      ..dealers = json['dealers'] == null
          ? null
          : Dealers.fromJson(json['dealers'] as Map<String, dynamic>)
      ..email = json['email'] as String?;

Map<String, dynamic> _$DealersEmailsToJson(DealersEmails instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'DealerID': instance.DealerID,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
      'dealers': instance.dealers?.toJson(),
      'email': instance.email,
    };

DealersPhone _$DealersPhoneFromJson(Map<String, dynamic> json) => DealersPhone()
  ..iD = json['iD'] as int?
  ..DealerID = json['DealerID'] as int?
  ..title = json['title'] as String?
  ..type = json['type'] as String?
  ..url = json['url'] as String?
  ..dealers = json['dealers'] == null
      ? null
      : Dealers.fromJson(json['dealers'] as Map<String, dynamic>)
  ..phone = json['phone'] as String?;

Map<String, dynamic> _$DealersPhoneToJson(DealersPhone instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'DealerID': instance.DealerID,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
      'dealers': instance.dealers?.toJson(),
      'phone': instance.phone,
    };

DealersSocial _$DealersSocialFromJson(Map<String, dynamic> json) =>
    DealersSocial()
      ..iD = json['iD'] as int?
      ..DealerID = json['DealerID'] as int?
      ..title = json['title'] as String?
      ..type = json['type'] as String?
      ..url = json['url'] as String?
      ..dealers = json['dealers'] == null
          ? null
          : Dealers.fromJson(json['dealers'] as Map<String, dynamic>);

Map<String, dynamic> _$DealersSocialToJson(DealersSocial instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'DealerID': instance.DealerID,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
      'dealers': instance.dealers?.toJson(),
    };
