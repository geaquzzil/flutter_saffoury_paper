import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/base_with_name_string.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_saffoury_paper/models/funds/money_funds.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'currency.g.dart';

@JsonSerializable()
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

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Currency fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) =>
      AppLocalizations.of(context)!.money_fund;
}
