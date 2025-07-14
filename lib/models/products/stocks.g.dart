// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stocks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stocks _$StocksFromJson(Map<String, dynamic> json) => Stocks()
  ..quantity = (json['quantity'] as num?)?.toDouble()
  ..warehouse = json['warehouse'] == null
      ? null
      : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>);

Map<String, dynamic> _$StocksToJson(Stocks instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'warehouse': instance.warehouse?.toJson(),
    };
