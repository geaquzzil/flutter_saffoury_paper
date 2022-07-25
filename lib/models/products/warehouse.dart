import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
part 'warehouse.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Warehouse extends BaseWithNameString<Warehouse> {
  Warehouse() : super();
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.warehouse;
  }

  @override
  IconData getMainIconData() => Icons.warehouse;
  @override
  String? getTableNameApi() => "warehouse";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 100};

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;

  factory Warehouse.fromJson(Map<String, dynamic> data) =>
      _$WarehouseFromJson(data);

  Map<String, dynamic> toJson() => _$WarehouseToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Warehouse fromJsonViewAbstract(Map<String, dynamic> json) =>
      Warehouse.fromJson(json);
}
