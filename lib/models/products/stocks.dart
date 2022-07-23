import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stocks.g.dart';

@JsonSerializable()
@reflector
class Stocks {
  double? quantity;
  Warehouse? warehouse;

  Stocks();
}
