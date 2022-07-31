import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'currency.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Currency extends BaseWithNameString<Currency> {
  String? nameAr;

  Currency() : super();

  @override
  List<String> getMainFields() => ["name", "nameAr"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.currency;
  }

  @override
  IconData getMainIconData() => Icons.currency_exchange_outlined;
  @override
  String? getTableNameApi() => "currency";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 50, "nameAr": 50};

  factory Currency.fromJson(Map<String, dynamic> data) =>
      _$CurrencyFromJson(data);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Currency fromJsonViewAbstract(Map<String, dynamic> json) =>
      Currency.fromJson(json);

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;
}
