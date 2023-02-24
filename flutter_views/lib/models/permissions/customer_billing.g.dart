// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingCustomer _$BillingCustomerFromJson(Map<String, dynamic> json) =>
    BillingCustomer()
      ..iD = json['iD'] as int
      ..delete = json['delete'] as bool?
      ..login = json['login'] as bool?
      ..permission = json['permission'] as bool?
      ..response = json['response'] as int?
      ..phone = json['phone'] as String?
      ..password = json['password'] as String?
      ..userlevels = json['userlevels'] == null
          ? null
          : PermissionLevelAbstract.fromJson(
              json['userlevels'] as Map<String, dynamic>)
      ..setting = json['setting'] == null
          ? null
          : Setting.fromJson(json['setting'] as Map<String, dynamic>)
      ..dealers = json['dealers'] == null
          ? null
          : Dealers.fromJson(json['dealers'] as Map<String, dynamic>);

Map<String, dynamic> _$BillingCustomerToJson(BillingCustomer instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'login': instance.login,
      'permission': instance.permission,
      'response': instance.response,
      'phone': instance.phone,
      'password': instance.password,
      'userlevels': instance.userlevels?.toJson(),
      'setting': instance.setting?.toJson(),
      'dealers': instance.dealers?.toJson(),
    };
