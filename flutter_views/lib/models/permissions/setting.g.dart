// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return Setting()
    ..iD = json['iD'] as int
    ..ENABLE_APP = json['ENABLE_APP'] as int?
    ..DISABLE_NOTIFICATIONS = json['DISABLE_NOTIFICATIONS'] as int?
    ..ENABLE_MULTI_EDIT = json['ENABLE_MULTI_EDIT'] as int?
    ..EXCHANGE_RATE = json['EXCHANGE_RATE'] as int?
    ..OLD_EXCHANGE_RATE = json['OLD_EXCHANGE_RATE'] as int?
    ..BUY_EXCHANGE_RATE = json['BUY_EXCHANGE_RATE'] as int?
    ..BUY_EXCHANGE_RATE_OLD = json['BUY_EXCHANGE_RATE_OLD'] as int?
    ..date = json['date'] as String?
    ..currency =
        _$enumDecodeNullable(_$CurrencySettingEnumMap, json['currency']);
}

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'iD': instance.iD,
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

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$CurrencySettingEnumMap = {
  CurrencySetting.DOLLAR: 'DOLLAR',
  CurrencySetting.DOLLAR_THREE_ZERO: 'DOLLAR_THREE_ZERO',
  CurrencySetting.SYP: 'SYP',
};
