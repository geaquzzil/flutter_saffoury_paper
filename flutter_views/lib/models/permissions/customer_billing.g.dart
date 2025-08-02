// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingCustomer _$BillingCustomerFromJson(Map<String, dynamic> json) =>
    BillingCustomer()
      ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
      ..serverStatus = json['serverStatus'] as String?
      ..fb_edit = json['fb_edit'] as String?
      ..phone = (json['phone'] as num?)?.toInt()
      ..password = json['password'] as String?
      ..userlevels =
          json['userlevels'] == null
              ? null
              : PermissionLevelAbstract.fromJson(
                json['userlevels'] as Map<String, dynamic>,
              )
      ..setting =
          json['setting'] == null
              ? null
              : Setting.fromJson(json['setting'] as Map<String, dynamic>)
      ..dealers =
          json['dealers'] == null
              ? null
              : Dealers.fromJson(json['dealers'] as Map<String, dynamic>)
      ..name = json['name'] as String?
      ..email = json['email'] as String?
      ..token = json['token'] as String?
      ..activated = (json['activated'] as num?)?.toInt()
      ..date = json['date'] as String?
      ..city = json['city'] as String?
      ..address = json['address'] as String?
      ..profile = json['profile'] as String?
      ..comments = ViewAbstractPermissions.convertToStringFromString(json['comments'])
      ..birthday = json['birthday'] as String?;

Map<String, dynamic> _$BillingCustomerToJson(BillingCustomer instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'phone': instance.phone,
      'password': instance.password,
      'userlevels': instance.userlevels?.toJson(),
      'setting': instance.setting?.toJson(),
      'dealers': instance.dealers?.toJson(),
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'activated': instance.activated,
      'date': instance.date,
      'city': instance.city,
      'address': instance.address,
      'profile': instance.profile,
      'comments': instance.comments,
      'birthday': instance.birthday,
    };
