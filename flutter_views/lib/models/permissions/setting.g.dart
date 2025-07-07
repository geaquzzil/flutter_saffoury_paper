// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting()
  ..iD = ViewAbstractPermissions.convertToMinusOneIfNotFound(json['iD'])
  ..serverStatus = json['serverStatus'] as String?
  ..fb_edit = json['fb_edit'] as String?
  ..ENABLE_APP = (json['ENABLE_APP'] as num?)?.toInt()
  ..DISABLE_NOTIFICATIONS = (json['DISABLE_NOTIFICATIONS'] as num?)?.toInt()
  ..ENABLE_MULTI_EDIT = (json['ENABLE_MULTI_EDIT'] as num?)?.toInt()
  ..EXCHANGE_RATE = (json['EXCHANGE_RATE'] as num?)?.toInt()
  ..OLD_EXCHANGE_RATE = (json['OLD_EXCHANGE_RATE'] as num?)?.toInt()
  ..BUY_EXCHANGE_RATE = (json['BUY_EXCHANGE_RATE'] as num?)?.toInt()
  ..BUY_EXCHANGE_RATE_OLD = (json['BUY_EXCHANGE_RATE_OLD'] as num?)?.toInt()
  ..date = json['date'] as String?
  ..currency = $enumDecodeNullable(_$CurrencySettingEnumMap, json['currency']);

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'iD': instance.iD,
      'delete': instance.delete,
      'ENABLE_APP': instance.ENABLE_APP,
      'DISABLE_NOTIFICATIONS': instance.DISABLE_NOTIFICATIONS,
      'ENABLE_MULTI_EDIT': instance.ENABLE_MULTI_EDIT,
      'EXCHANGE_RATE': instance.EXCHANGE_RATE,
      'OLD_EXCHANGE_RATE': instance.OLD_EXCHANGE_RATE,
      'BUY_EXCHANGE_RATE': instance.BUY_EXCHANGE_RATE,
      'BUY_EXCHANGE_RATE_OLD': instance.BUY_EXCHANGE_RATE_OLD,
      'date': instance.date,
      'currency': _$CurrencySettingEnumMap[instance.currency],
    };

const _$CurrencySettingEnumMap = {
  CurrencySetting.DOLLAR: 'DOLLAR',
  CurrencySetting.DOLLAR_THREE_ZERO: 'DOLLAR_THREE_ZERO',
  CurrencySetting.SYP: 'SYP',
};
