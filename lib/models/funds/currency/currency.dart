import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Currency extends BaseWithNameString<Currency> {
  String? nameAr;

  Currency() : super();

  Currency.init(BuildContext context) {
    nameAr = AppLocalizations.of(context)!.sypDots;
    name = AppLocalizations.of(context)!.sypDots;
    iD = 1;
  }
  @override
  Currency getSelfNewInstance() {
    return Currency();
  }

  @override
  String getForeignKeyName() {
    return "CurrencyID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()..addAll({"nameAr": ""});

  @override
  List<String> getMainFields({BuildContext? context}) => ["name", "nameAr"];
  bool isDollar() {
    return iD == 1;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.currency;
  }

  String getModifiableMainGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;

  @override
  IconData getMainIconData() => Icons.currency_exchange_outlined;
  @override
  String? getTableNameApi() => "currency";

  @override
  Map<String, int> getTextInputMaxLengthMap() => {"name": 10, "nameAr": 40};

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
