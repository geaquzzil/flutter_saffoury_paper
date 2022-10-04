// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'dealer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dealers _$DealersFromJson(Map<String, dynamic> json) => Dealers()
  ..iD = json['iD'] as int
  ..name = json['name'] as String?
  ..nameAr = json['nameAr'] as String?
  ..commNum = json['commNum'] as int?
  ..address = json['address'] as String?
  ..addressAr = json['addressAr'] as String?
  ..dealers_emails_count = json['dealers_emails_count'] as int?
  ..dealers_phones_count = json['dealers_phones_count'] as int?
  ..dealers_social_count = json['dealers_social_count'] as int?
  ..dealers_emails = (json['dealers_emails'] as List<dynamic>?)
      ?.map((e) => DealersEmails.fromJson(e as Map<String, dynamic>))
      .toList()
  ..dealers_phones = (json['dealers_phones'] as List<dynamic>?)
      ?.map((e) => DealersPhone.fromJson(e as Map<String, dynamic>))
      .toList()
  ..dealers_social = (json['dealers_social'] as List<dynamic>?)
      ?.map((e) => DealersSocial.fromJson(e as Map<String, dynamic>))
      .toList();

DealersEmails _$DealersEmailsFromJson(Map<String, dynamic> json) =>
    DealersEmails()
      ..iD = json['iD'] as int
      ..DealerID = json['DealerID'] as int?
      ..email = json['email'] as String?
      ..title = json['title'] as String?
      ..type = json['type'] as String?
      ..url = json['url'] as String?
      ..dealers = json['dealers'] == null
          ? null
          : Dealers.fromJson(json['dealers'] as Map<String, dynamic>);

DealersSocial _$DealersSocialFromJson(Map<String, dynamic> json) =>
    DealersSocial()
      ..iD = json['iD'] as int
      ..DealerID = json['DealerID'] as int?
      ..title = json['title'] as String?
      ..type = json['type'] as String?
      ..url = json['url'] as String?
      ..dealers = json['dealers'] == null
          ? null
          : Dealers.fromJson(json['dealers'] as Map<String, dynamic>);

DealersPhone _$DealersPhoneFromJson(Map<String, dynamic> json) =>
    DealersPhone()
      ..iD = json['iD'] as int
      ..DealerID = json['DealerID'] as int?
      ..title = json['title'] as String?
      ..phone = json['phone'] as String?
      ..type = json['type'] as String?
      ..url = json['url'] as String?
      ..dealers = json['dealers'] == null
          ? null
          : Dealers.fromJson(json['dealers'] as Map<String, dynamic>);
