import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stocks.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Stocks {
  double? quantity;
  Warehouse? warehouse;

  Stocks();

  factory Stocks.fromJson(Map<String, dynamic> data) => _$StocksFromJson(data);

  Map<String, dynamic> toJson() => _$StocksToJson(this);
}
