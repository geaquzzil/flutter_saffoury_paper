import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'qualities.g.dart';

@JsonSerializable(explicitToJson: true)

@reflector
class Quality extends BaseWithNameString<Quality> {
  List<Product>? products;
  int? products_count;

  Quality() : super();
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.quality;
  }

  @override
  IconData getMainIconData() => Icons.query_stats;
  @override
  String? getTableNameApi() => "qualities";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 50};

  factory Quality.fromJson(Map<String, dynamic> data) =>
      _$QualityFromJson(data);

  Map<String, dynamic> toJson() => _$QualityToJson(this);

  @override
  Quality fromJsonViewAbstract(Map<String, dynamic> json) {
    return Quality.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.product;
}
